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

C $Id: prnsel.f,v 1.1 2009/03/25 04:47:54 gdsjaar Exp $
C $Log: prnsel.f,v $
C Revision 1.1  2009/03/25 04:47:54  gdsjaar
C Added blotII2 source since Copyright was asserted.
C
C Update copyright notice in suplib.
C
C Add blotII2 to config files.  Note that blot will not build yet since
C it requires some libraries that are still being reviewed for copyright
C assertion.
C
C Revision 1.1  1994/04/07 20:07:54  gdsjaar
C Initial checkin of ACCESS/graphics/blotII2
C
c Revision 1.3  1992/05/22  22:37:29  gdsjaar
c Modified to handle more than 100,000 nodes/elements in printouts
c
c Revision 1.2  1990/12/14  08:55:18  gdsjaar
c Added RCS Id and Log to all files
c
C=======================================================================
      SUBROUTINE PRNSEL (NSEL, NTOT, VALNAM)
C=======================================================================

C   --*** PRNSEL *** (BLOT) Print number of values selected
C   --   Written by Amy Gilkey - revised 03/02/88
C   --
C   --PRNSEL prints the number of values selected.
C   --
C   --Parameters:
C   --   NSEL - IN - the number of values selected
C   --   NTOT - IN - the total number of values
C   --   VALNAM - IN - the name of the value being checked (plural)

      CHARACTER*(*) VALNAM

      CHARACTER*80 STRING

      IF (NSEL .LE. 0) THEN
         WRITE (STRING, '(5A)') 'No ', VALNAM, ' are selected'
         CALL PRTERR ('CMDWARN', STRING(:LENSTR(STRING)))
      ELSE
         WRITE (STRING, 10000) NSEL, NTOT, VALNAM
10000     FORMAT (I6, ' of ', I6, ' ', A, ' selected')
         CALL SQZSTR (STRING, LSTR)
         WRITE (*, 10010) STRING(:LSTR)
      END IF

      RETURN
10010  FORMAT (4X, A)
      END
