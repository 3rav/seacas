C Copyright(C) 2009 Sandia Corporation. Under the terms of Contract
C DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains
C certain rights in this software.
C         
C Redistribution and use in source and binary forms, with or without
C modification, are permitted provided that the following conditions are
C met:
C 
C     * Redistributions of source code must retain the above copyright
C       notice, this list of conditions and the following disclaimer.
C 
C     * Redistributions in binary form must reproduce the above
C       copyright notice, this list of conditions and the following
C       disclaimer in the documentation and/or other materials provided
C       with the distribution.
C     * Neither the name of Sandia Corporation nor the names of its
C       contributors may be used to endorse or promote products derived
C       from this software without specific prior written permission.
C 
C THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
C "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
C LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
C A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
C OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
C SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
C LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
C DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
C THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
C (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
C OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

C $Id: msgeom.f,v 1.1 2009/03/25 04:47:53 gdsjaar Exp $
C $Log: msgeom.f,v $
C Revision 1.1  2009/03/25 04:47:53  gdsjaar
C Added blotII2 source since Copyright was asserted.
C
C Update copyright notice in suplib.
C
C Add blotII2 to config files.  Note that blot will not build yet since
C it requires some libraries that are still being reviewed for copyright
C assertion.
C
C Revision 1.2  2007/11/14 20:14:53  gdsjaar
C Added optional 'alive value' to the death on variable command.  The
C default value is 0.0, but you can now specify a different value to
C indicate aliveness (for example, the presto DEATH_DUMMY_VAR treats 1.0
C as the alive value).
C
C Example: DEATH ON DEATH_DUMMY_VAR 1
C
C Revision 1.1  1994/04/07 20:05:28  gdsjaar
C Initial checkin of ACCESS/graphics/blotII2
C
c Revision 1.2  1990/12/14  08:53:48  gdsjaar
c Added RCS Id and Log to all files
c
C=======================================================================
      SUBROUTINE MSGEOM (A, CURPRO, ISTEP,
     &   LENF, NLNKF, KLINKF, KXN, KYN, KZN,
     &   KIF2EL, NEWELB, IELBST, NEWFAC, FIXFAC)
C=======================================================================

C   --*** MSGEOM *** (MESH) Correct the mesh faces
C   --   Written by Amy Gilkey - revised 05/27/88
C   --
C   --MSGEOM determines the new face array, if it has changed.
C   --It handles new displayed element blocks, a new "cut" through the mesh,
C   --and element birth/death (for the time step).  A flag is set if the
C   --faces are changed.
C   --
C   --This routine reserves and sets the following dynamic memory arrays:
C   --   IX2NP - the node number for each mesh index (MASTER process only)
C   --
C   --This routine uses MDFIND to find the following dynamic memory arrays:
C   --   IF2EL2 - the secondary element number of each face
C   --   IE2ELB - the element block for each element
C   --   XN, YN, ZN - IN - the full set of nodal coordinates (ZN for 3D only)
C   --   LENE - the cumulative element counts by element block
C   --   ISEVOK - the element block variable truth table;
C   --      variable i of block j exists iff ISEVOK(j,i)
C   --
C   --Parameters:
C   --   A - IN - the dynamic memory base array
C   --   CURPRO - IN - the name of the program that changed the faces
C   --   ISTEP - IN - the time step number
C   --   LENF - IN/OUT - the cumulative face counts by element block
C   --      LENF(0) is always 0
C   --      LENF(1..NELBLK) is the end of the surface faces of element block (i)
C   --      LENF(NELBLK+1) is the end of the interior faces
C   --      LENF(NELBLK+2) is the end of the faces that are dead
C   --      LENF(NELBLK+3) is the end of the faces outside a cut
C   --      LENF(NELBLK+4) is the end of the faces in a non-selected block
C   --   NLNKF - IN - the number of nodes per face
C   --   KLINKF - IN/OUT - the index of LINKF - the connectivity for all faces
C   --   KXN, KYN, KZN - IN - the indices of XN, YN, ZN -
C   --      the nodal coordinates (ZN for 3D only)
C   --   KIF2EL - IN/OUT - the index of IF2EL - the element number of each face
C   --   NEWELB - IN/OUT - the new element blocks flag:
C   --      0 = no new element blocks
C   --      1 = new selected element blocks
C   --      2 = new displayed element blocks (implies new selected blocks)
C   --   IELBST - IN - the element block status:
C   --      -1 = OFF, 0 = ON, but not selected, 1 = selected
C   --   NEWFAC - OUT - set true if the faces are changed, else false
C   --   FIXFAC - OUT - set true if the program that last set the faces is
C   --      not the current program (some program-specific values may need
C   --      to be reset), else false
C   --
C   --Common Variables:
C   --   Uses NDIM, NUMEL, NELBLK of /DBNUMS/
C   --   Uses IS3DIM of /D3NUMS/
C   --   Uses NALVAR of /MSHOPT/
C   --   Sets and uses NEWROT, ROTMAT, ROTCEN of /ROTOPT/
C   --   Sets and uses NEWCUT, ISCUT, CUTPT, CUTNRM of /CUTOPT/

      include 'dbnums.blk'
      include 'd3nums.blk'
      include 'mshopt.blk'
      COMMON /ROTOPT/ NEWROT, ROTMAT(3,3), ROTCEN(3), EYE(3)
      LOGICAL NEWROT
      COMMON /CUTOPT/ NEWCUT, ISCUT, CUTPT(3), CUTNRM(3)
      LOGICAL NEWCUT, ISCUT

      common /dualpr/ proces
      character*8 proces

      DIMENSION A(*)
      CHARACTER*(*) CURPRO
      INTEGER LENF(0:NELBLK+4)
      INTEGER NLNKF(NELBLK)
      INTEGER NEWELB
      INTEGER IELBST(NELBLK)
      LOGICAL NEWFAC
      LOGICAL FIXFAC

      LOGICAL FIRST
      SAVE FIRST
C      --FIRST - true iff first time through routine

      CHARACTER*8 LSTPRO
      SAVE LSTPRO
C      --LSTPRO - the last program to set the faces

      INTEGER NALOLD
      SAVE NALOLD
C      --NALOLD - the last setting of NALVAR

      DATA FIRST / .TRUE. /
      DATA NALOLD / 0 /
      DATA LSTPRO / '        ' /

C   --Figure out if new face set needs to be calculated

      NEWFAC = .FALSE.

      IF (FIRST) THEN
         if (proces .eq. 'MASTER') then
            NEWFAC = .TRUE.
         end if
         LSTPRO = CURPRO
      END IF

      IF (IS3DIM .AND. (NEWELB .EQ. 2)) THEN
         NEWFAC = .TRUE.
      END IF

      IF (IS3DIM .AND. NEWCUT) THEN
         NEWFAC = .TRUE.
      END IF

      IF ((NALOLD .GT. 0) .AND. (NALVAR .LE. 0)) THEN
         NEWFAC = .TRUE.
      END IF

      IF ((NALVAR .GT. 0) .AND. (ISTEP .GE. 1)) THEN
         NEWFAC = .TRUE.
      END IF

      IF (NEWFAC) THEN

         if (proces .eq. 'MASTER') then
            CALL MDRSRV ('SCR', KPACK, 1 + 2 + (1+NELBLK) + 12)
            CALL MDSTAT (NERR, MEM)
            IF (NERR .GT. 0) GOTO 100

            CALL REQMLK ('*', ISTEP, NALVAR, DEADNP,
     &         NELBLK, NEWELB, IELBST,
     &         NEWCUT, ISCUT, CUTPT, CUTNRM, A(KPACK), *110)

            CALL MDDEL ('SCR')

            CALL RCVMLK ('H', NELBLK, LENF, NLNKF, IDUM, IDUM, *110)

            CALL CNTLNK (NELBLK, LENF, NLNKF, N, IDUM)
            CALL MDLONG ('LINKF', KLINKF, 0)
            CALL MDLONG ('LINKF', KLINKF, N)
            CALL MDLONG ('IF2EL', KIF2EL, 0)
            CALL MDLONG ('IF2EL', KIF2EL, LENF(NELBLK))
            CALL MDSTAT (NERR, MEM)
            IF (NERR .GT. 0) GOTO 110

            CALL RCVMLK ('CE', NELBLK, LENF, NLNKF,
     &         A(KIF2EL), A(KLINKF), *110)

            CALL RCVMXY ('H',
     &         NUMNPF, NDIM, RDUM, RDUM, RDUM, IDUM,
     &         .FALSE., IDUM, RDUM, *110)

            CALL MDLONG ('IX2NP', KIX2NP, 0)
            CALL MDLONG ('IX2NP', KIX2NP, NUMNPF)
            CALL MDLONG ('XNM', KXN, 0)
            CALL MDLONG ('XNM', KXN, NUMNPF)
            CALL MDLONG ('YNM', KYN, 0)
            CALL MDLONG ('YNM', KYN, NUMNPF)
            IF (IS3DIM) THEN
               CALL MDLONG ('ZNM', KZN, 0)
               CALL MDLONG ('ZNM', KZN, NUMNPF)
            END IF
            CALL MDRSRV ('SCR', KPACK, NDIM * NUMNPF)
            CALL MDSTAT (NERR, MEM)
            IF (NERR .GT. 0) GOTO 100

            CALL RCVMXY ('NC',
     &         NUMNPF, NDIM, A(KXN), A(KYN), A(KZN), A(KIX2NP),
     &         .FALSE., IDUM, A(KPACK), *100)

            CALL MDDEL ('SCR')
         end if
      END IF

C   --Compute new face set if element blocks have been turned on/off

      IF (IS3DIM .AND. (NEWELB .EQ. 2)) THEN
         if (proces .ne. 'MASTER') then

C         --Determine new face set for new element blocks

            NSETS = NELBLK + 4
            CALL MDRSRV ('NEWELB', KNEWB, LENF(NSETS))
            IF (IS3DIM) CALL MDFIND ('IF2EL2', KIF2E2, IDUM)
            CALL MDFIND ('IE2ELB', KE2ELB, IDUM)
            CALL MDSTAT (NERR, MEM)
            IF (NERR .GT. 0) GOTO 100

            CALL FIXELB (IELBST, LENF, A(KIF2EL), A(KIF2E2), A(KE2ELB),
     &         A(KNEWB))

C         --Adjust the face connectivity

            CALL SORLNK (A, NSETS, A(KNEWB),
     &         LENF, NLNKF, A(KLINKF), A(KIF2EL), A(KIF2E2), A(KE2ELB))

            CALL MDDEL ('NEWELB')
         end if

C      --If no faces are ON, print error message
C      --and go back for more commands with NEWELB set

         IF (LENF(NELBLK) .EQ. 0) THEN
            CALL PRTERR ('ERROR', 'No element blocks are displayed')
            NEWELB = 2
            GOTO 100
         END IF

C      --Force the re-calculation of the cut, if cut
         IF (ISCUT) NEWCUT = .TRUE.

C      --All faces are now alive
         NALOLD = 0

C      --Force the re-calculation of connected element count, if needed
         NEWELB = 1
      END IF

C   --Compute new face set if the object has been cut

      IF (IS3DIM .AND. NEWCUT) THEN
         if (proces .ne. 'MASTER') then

C         --Compute new face set for cut

            NSETS = NELBLK + 3
            CALL MDRSRV ('NEWELB', KNEWB, LENF(NSETS))
            IF (IS3DIM) CALL MDFIND ('IF2EL2', KIF2E2, IDUM)
            CALL MDFIND ('IE2ELB', KE2ELB, IDUM)
            CALL MDSTAT (NERR, MEM)
            IF (NERR .GT. 0) GOTO 100

            IF (ISCUT) THEN
               CALL MDRSRV ('SCRFAC', KFSTAT, LENF(NELBLK+3))
               CALL MDRSRV ('ROUTEL', KESTAT, NUMEL)
               CALL MDRSRV ('ROUTZC', KZC, NUMNP)
C            --Get the full set of coordinates
               CALL MDFIND ('XN', KX, IDUM)
               CALL MDFIND ('YN', KY, IDUM)
               CALL MDFIND ('ZN', KZ, IDUM)
               CALL MDSTAT (NERR, MEM)
               IF (NERR .GT. 0) GOTO 100

               CALL FIXCUT (CUTPT, CUTNRM, A(KX), A(KY), A(KZ),
     &            LENF, NLNKF, A(KLINKF),
     &            A(KIF2EL), A(KIF2E2), A(KE2ELB),
     &            A(KFSTAT), A(KESTAT), A(KZC), A(KNEWB))

               CALL MDDEL ('SCRFAC')
               CALL MDDEL ('ROUTEL')
               CALL MDDEL ('ROUTZC')

            ELSE
               CALL ALLCUT (A(KE2ELB), LENF, A(KIF2EL), A(KIF2E2),
     &            A(KNEWB))
            END IF

C         --Adjust the face connectivity

            CALL SORLNK (A, NSETS, A(KNEWB),
     &         LENF, NLNKF, A(KLINKF), A(KIF2EL), A(KIF2E2), A(KE2ELB))

            CALL MDDEL ('NEWELB')
         end if

C      --If no faces are defined by cut, delete cut, print error message
C      --and go back for more commands with NEWCUT set

         IF (LENF(NELBLK) .EQ. 0) THEN
            CALL PRTERR ('ERROR',
     &         'No elements are defined by the cutting plane')
            NEWCUT = .TRUE.
            GOTO 100
         END IF

C      --All faces are now alive
         NALOLD = 0

         NEWCUT = .FALSE.
      END IF

C   --Compute new face set (and line set for 2D) for birth/death turned off

      IF ((NALOLD .GT. 0) .AND. (NALVAR .LE. 0)) THEN
         if (proces .ne. 'MASTER') then

C         --Compute new face set for birth/death turned off

            NSETS = NELBLK + 2
            CALL MDRSRV ('NEWELB', KNEWB, LENF(NSETS))
            IF (IS3DIM) CALL MDFIND ('IF2EL2', KIF2E2, IDUM)
            CALL MDFIND ('IE2ELB', KE2ELB, IDUM)
            CALL MDSTAT (NERR, MEM)
            IF (NERR .GT. 0) GOTO 100

            IF (.NOT. IS3DIM) THEN
               CALL ALLAL2 (LENF, A(KIF2EL), A(KE2ELB), A(KNEWB))
            ELSE
               CALL ALLAL3 (LENF, A(KIF2EL), A(KIF2E2), A(KE2ELB),
     &            A(KNEWB))
            END IF

C         --Adjust the face connectivity

            CALL SORLNK (A, NSETS, A(KNEWB),
     &         LENF, NLNKF, A(KLINKF), A(KIF2EL), A(KIF2E2), A(KE2ELB))

            CALL MDDEL ('NEWELB')
         end if

         NALOLD = NALVAR
      END IF

C   --Compute new face set (and line set for 2D) for birth/death for step

      IF ((NALVAR .GT. 0) .AND. (ISTEP .GE. 1)) THEN
         if (proces .ne. 'MASTER') then

C         --Compute new face set for birth/death for step

            NSETS = NELBLK + 2
            CALL MDRSRV ('NEWELB', KNEWB, LENF(NSETS))
            IF (IS3DIM) CALL MDFIND ('IF2EL2', KIF2E2, IDUM)
            CALL MDFIND ('IE2ELB', KE2ELB, IDUM)

            CALL MDRSRV ('ROUTEL', KALIVE, NUMEL)
            CALL MDFIND ('LENE', KLENE, IDUM)
            CALL MDFIND ('ISEVOK', KIEVOK, IDUM)
            CALL MDSTAT (NERR, MEM)
            IF (NERR .GT. 0) GOTO 100

            CALL GETALV (A, NALVAR, ALIVAL, ISTEP, A(KLENE), A(KIEVOK),
     &         A(KALIVE), A(KALIVE))

            IF (.NOT. IS3DIM) THEN
               CALL FIXAL2 (A(KALIVE),
     &            LENF, A(KIF2EL), A(KE2ELB), A(KNEWB))
            ELSE
               CALL FIXAL3 (A(KALIVE),
     &            LENF, A(KIF2EL), A(KIF2E2), A(KE2ELB), A(KNEWB))
            END IF

            CALL MDDEL ('ROUTEL')

C         --Adjust the face connectivity

            CALL SORLNK (A, NSETS, A(KNEWB),
     &         LENF, NLNKF, A(KLINKF), A(KIF2EL), A(KIF2E2), A(KE2ELB))

            CALL MDDEL ('NEWELB')
         end if

C      --If no faces are alive, print error message
C      --and skip time step

         IF (LENF(NELBLK) .EQ. 0) THEN
            CALL PRTERR ('ERROR', 'No elements are alive')
            GOTO 100
         END IF

         NALOLD = NALVAR
      END IF

  100 CONTINUE

      IF (NEWFAC) THEN

C      --Force the re-calculation of which nodes are on the surface
         NNPSUR = -999
      END IF

      IF (NEWFAC) LSTPRO = CURPRO
      FIXFAC = (CURPRO .NE. LSTPRO)

      FIRST = .FALSE.

  110 CONTINUE
      RETURN
      END
