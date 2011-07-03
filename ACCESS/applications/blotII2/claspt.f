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

C $Id: claspt.f,v 1.1 2009/03/25 04:47:53 gdsjaar Exp $
C $Log: claspt.f,v $
C Revision 1.1  2009/03/25 04:47:53  gdsjaar
C Added blotII2 source since Copyright was asserted.
C
C Update copyright notice in suplib.
C
C Add blotII2 to config files.  Note that blot will not build yet since
C it requires some libraries that are still being reviewed for copyright
C assertion.
C
C Revision 1.2  1996/06/21 16:07:01  caforsy
C Ran ftnchek and removed unused variables.  Reformat output for list
C var, list global, and list name.
C
C Revision 1.1  1994/04/07 19:55:47  gdsjaar
C Initial checkin of ACCESS/graphics/blotII2
C
c Revision 1.2  1990/12/14  08:48:10  gdsjaar
c Added RCS Id and Log to all files
c
      subroutine claspt( xpt, ypt, zpt, cutpt, cutnrm, status)

      real xpt, ypt, zpt
      real cutpt(3), cutnrm(3)
      integer status
      parameter(ISIN=1, ISON=-2, ISOUT=-1)
      real vec(3)
      real tol
      parameter(REFTOL=1e-4)
c
c check dot product of normal vector and (pt-cutpt) vector to find
c if point is in front or behind plane
c
      vec(1) = xpt - cutpt(1)
      vec(2) = ypt - cutpt(2)
      vec(3) = zpt - cutpt(3)
c      tol = amax1( vec(1), vec(2), vec(3) ) * REFTOL
      tol = REFTOL
      dot = vec(1)*cutnrm(1) + vec(2)*cutnrm(2) + vec(3)*cutnrm(3)

      if( abs(dot) .lt. tol) then
          status = ISON
      else if(dot .gt. 0.0) then
          status = ISOUT
      else
          status = ISIN
      end if
c
      return
      end
