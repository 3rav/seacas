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

C $Id: dbsbel.f,v 1.1 2009/03/25 04:47:53 gdsjaar Exp $
C $Log: dbsbel.f,v $
C Revision 1.1  2009/03/25 04:47:53  gdsjaar
C Added blotII2 source since Copyright was asserted.
C
C Update copyright notice in suplib.
C
C Add blotII2 to config files.  Note that blot will not build yet since
C it requires some libraries that are still being reviewed for copyright
C assertion.
C
C Revision 1.1  1994/04/07 19:59:05  gdsjaar
C Initial checkin of ACCESS/graphics/blotII2
C
c Revision 1.2  1990/12/14  08:49:14  gdsjaar
c Added RCS Id and Log to all files
c
C=======================================================================
      SUBROUTINE DBSBEL (NELBLK, NUMEL, LENE, INEL, NLISEL, LISEL)
C=======================================================================

C   --*** DBSBEL *** (BLOT) Select elements given list of elements
C   --   Written by Amy Gilkey - revised 01/05/88
C   --
C   --DBSBEL creates the element block selection array and the element
C   --selection array (by block) given a list of selected elements.
C   --
C   --Parameters:
C   --   NELBLK - IN - the number of element blocks
C   --   NUMEL - IN - the number of elements
C   --   LENE - IN - the cumulative element counts by element block
C   --   INEL - IN - the indices of the selected elements
C   --   NLISEL - IN/OUT - the number of selected elements for each block
C   --   LISEL - IN/OUT - the indices of the selected elements (by block)

      INTEGER LENE(0:*)
      INTEGER INEL(0:*)
      INTEGER NLISEL(0:*)
      INTEGER LISEL(0:*)

      LISEL(0) = 0
      CALL INIINT (NUMEL, 0, LISEL(1))

      NLISEL(0) = 0
      DO 110 IELB = 1, NELBLK
         IEL = LENE(IELB-1)+1
         LEL = LENE(IELB)
         NEL = 0
         DO 100 I = 1, INEL(0)
            IF ((INEL(I) .GE. IEL) .AND. (INEL(I) .LE. LEL)) THEN
               LISEL(IEL+NEL) = INEL(I)
               NEL = NEL + 1
            END IF
  100    CONTINUE
         LISEL(0) = LISEL(0) + NEL
         NLISEL(IELB) = NEL
         IF (NEL .GT. 0) NLISEL(0) = NLISEL(0) + 1
  110 CONTINUE

      RETURN
      END
