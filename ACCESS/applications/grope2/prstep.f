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
      SUBROUTINE PRSTEP (OPTION, NOUT, TIME, NCSTEP, NSTEPS)
C=======================================================================

C   --*** PRSTEP *** (GROPE) Display current database time and step number
C   --   Written by Amy Gilkey - revised 01/18/88
C   --
C   --PRSTEP displays the time and the step number of the current time step.
C   --
C   --Parameters:
C   --   OPTION - IN - '*' to print all, else print options
C   --   NOUT - IN - the output file, <=0 for standard
C   --   TIME - IN - the current time step time
C   --   NCSTEP - IN - the current time step number
C   --   NSTEPS - IN - the number of time steps

      CHARACTER*(*) OPTION

      CHARACTER*20 STRA, STRB
      CHARACTER*20 RSTR

      INTEGER NPREC
      INTEGER GETPRC

      NPREC=GETPRC()

      STRA = 'time step'
      LSTRA = LENSTR (STRA)
      CALL NUMSTR (1, NPREC, TIME, RSTR, LRSTR)
      WRITE (STRB, 10000, IOSTAT=IDUM) NCSTEP, NSTEPS
10000  FORMAT (I10, ' of ', I10)
      CALL SQZSTR (STRB, LSTRB)
      IF (NOUT .GT. 0) THEN
         WRITE (NOUT, *)
         WRITE (NOUT, 10010)
     &      RSTR(:LRSTR), STRA(:LSTRA), STRB(:LSTRB)
      ELSE
         WRITE (*, 10010)
     &      RSTR(:LRSTR), STRA(:LSTRA), STRB(:LSTRB)
      END IF

      RETURN
10010  FORMAT (1X, 'Time = ', A, ' (', A, ' ', A, ')')
      END
