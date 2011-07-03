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

C $Id: scahis.f,v 1.1 2009/03/25 04:47:54 gdsjaar Exp $
C $Log: scahis.f,v $
C Revision 1.1  2009/03/25 04:47:54  gdsjaar
C Added blotII2 source since Copyright was asserted.
C
C Update copyright notice in suplib.
C
C Add blotII2 to config files.  Note that blot will not build yet since
C it requires some libraries that are still being reviewed for copyright
C assertion.
C
C Revision 1.2  2009/01/22 21:34:22  gdsjaar
C There were several inline dbnums common blocks. Replaced with the
C include so they all have the same size with the added variable types.
C
C Added minor support for nodeset and sideset variables.
C
C It can print the count and the names, but that is all
C at this time.
C
C Revision 1.1  1994/04/07 20:10:42  gdsjaar
C Initial checkin of ACCESS/graphics/blotII2
C
c Revision 1.2  1990/12/14  08:56:54  gdsjaar
c Added RCS Id and Log to all files
c
C=======================================================================
      SUBROUTINE SCAHIS (A, VAR, WHOTIM,
     &   VALMIN, ISTMIN, VALMAX, ISTMAX)
C=======================================================================

C   --*** SCAHIS *** (BLOT) Scale all history variables
C   --   Written by Amy Gilkey - revised 04/01/88
C   --
C   --SCAHIS reads the values for the history variables from the database
C   --and finds the minimum and maximum values.
C   --
C   --Parameters:
C   --   A - IN - the dynamic memory base array
C   --   VAR - SCRATCH - the variable array
C   --   WHOTIM - IN - true iff time step is a whole (versus history) time step
C   --   VALMIN, VALMAX - OUT - the minimum and maximum value for each variable
C   --   ISTMIN, ISTMAX - OUT - the step number of the minimum and maximum
C   --      value for each variable
C   --
C   --Common Variables:
C   --   Uses NVARHI, NSTEPS of /DBNUMS/

      include 'dbnums.blk'

      DIMENSION A(*)
      REAL VAR(NVARHI)
      LOGICAL WHOTIM(*)
      REAL VALMIN(NVARHI), VALMAX(NVARHI)
      INTEGER ISTMIN(NVARHI), ISTMAX(NVARHI)

      CALL DBVIX ('H', 1, IVAR)

      DO 110 ISTEP = 1, NSTEPS

C      --Read the variables

         CALL GETVAR (A, IVAR, -999, ISTEP, NVARHI, VAR)

C      --Find minimum and maximum variable values for each variable

         DO 100 IXVAR = 1, NVARHI

            IF (ISTEP .EQ. 1) THEN
               VALMIN(IXVAR) = VAR(IXVAR)
               ISTMIN(IXVAR) = ISTEP
               VALMAX(IXVAR) = VAR(IXVAR)
               ISTMAX(IXVAR) = ISTEP
            ELSE IF (VALMIN(IXVAR) .GT. VAR(IXVAR)) THEN
               VALMIN(IXVAR) = VAR(IXVAR)
               ISTMIN(IXVAR) = ISTEP
            ELSE IF (VALMAX(IXVAR) .LT. VAR(IXVAR)) THEN
               VALMAX(IXVAR) = VAR(IXVAR)
               ISTMAX(IXVAR) = ISTEP
            END IF

  100    CONTINUE
  110 CONTINUE

      RETURN
      END
