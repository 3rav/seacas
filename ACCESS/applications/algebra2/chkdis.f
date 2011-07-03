C    Copyright(C) 2008 Sandia Corporation.  Under the terms of Contract
C    DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains
C    certain rights in this software
C    
C    Redistribution and use in source and binary forms, with or without
C    modification, are permitted provided that the following conditions are
C    met:
C    
C    * Redistributions of source code must retain the above copyright
C       notice, this list of conditions and the following disclaimer.
C              
C    * Redistributions in binary form must reproduce the above
C      copyright notice, this list of conditions and the following
C      disclaimer in the documentation and/or other materials provided
C      with the distribution.
C                            
C    * Neither the name of Sandia Corporation nor the names of its
C      contributors may be used to endorse or promote products derived
C      from this software without specific prior written permission.
C                                                    
C    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
C    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
C    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
C    A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
C    OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
C    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
C    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
C    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
C    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
C    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
C    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
C    
C=======================================================================
      SUBROUTINE CHKDIS (NDIM, NAMECO, NVARNP, NAMENV)
C=======================================================================
C $Id: chkdis.f,v 1.1 2008/10/31 05:04:00 gdsjaar Exp $
C $Log: chkdis.f,v $
C Revision 1.1  2008/10/31 05:04:00  gdsjaar
C Moved the applications into an applications subdirectory.
C
C Revision 1.1  2008/06/18 16:00:25  gdsjaar
C Initial adding of files to sourceforge
C
C Revision 1.4  2008/03/14 13:45:25  gdsjaar
C Added copyright information to top of all files.
C
C ALGEBRA2 is now open-sourced under BSD license
C
C Revision 1.3  1995/10/03 21:35:58  mksmith
C Removing old algII files
C Replacing modified algII files
C
C Revision 1.2  1993/08/02 14:20:37  gdsjaar
C Split out common blocks into separare files. Miscellaneous bug fixes
C on several files.  First public release version.
C
c Revision 1.1  1993/07/30  21:41:48  gdsjaar
c Initial checkin of ACCESS/translate/algII
c
c Revision 1.1.1.1  1990/11/09  16:23:32  gdsjaar
c Algebra - Unix Version
c
c Revision 1.1  90/11/09  16:23:31  gdsjaar
c Initial revision
c 

C   --*** CHKDIS *** (ALGEBRA) Check displacement variables
C   --   Written by Amy Gilkey - revised 03/02/88
C   --
C   --CHKDIS finds the displacement variables.  The first two/three nodal
C   --variables are displacement variables if and only if they begin with
C   --'D' and end with the last character of the corresponding coordinate
C   --name.
C   --
C   --Parameters:
C   --   NDIM   - IN - the number of coordinates
C   --   NAMECO - IN - the coordinate names
C   --   NVARNP - IN - the number of nodal variables
C   --   NAMENV - IN - the nodal variable names

      include 'params.blk'

      CHARACTER*(MXSTLN) NAMECO(*)
      CHARACTER*(MXSTLN) NAMENV(*)

      LOGICAL DEFOK

      IF (NVARNP .GE. NDIM) THEN
         DEFOK = .TRUE.
         LN = MAX (LENSTR (NAMENV(1)), 2)
         DO 100 I = 1, NDIM
            LC = LENSTR (NAMECO(I))
            IF ((NAMENV(I)(1:1) .NE. 'D')
     &         .OR. (NAMENV(I)(1:LN-1) .NE. NAMENV(1)(1:LN-1))
     &         .OR. (NAMENV(I)(LN:LN) .NE. NAMECO(I)(LC:LC)))
     &         DEFOK = .FALSE.
  100    CONTINUE

      ELSE
         DEFOK = .FALSE.
      END IF

      IF (.NOT. DEFOK) THEN
         CALL PRTERR ('WARNING', 'Output database will not have'
     &      // ' a valid set of displacement functions.')
      END IF

      RETURN
      END
