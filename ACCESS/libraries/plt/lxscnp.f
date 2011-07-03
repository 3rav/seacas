C Copyright (C) 2009 Sandia Corporation.  Under the terms of Contract
C DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains
C certain rights in this software
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
C 
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
C 

C $Id: lxscnp.f,v 1.1 2009/06/10 18:23:54 gdsjaar Exp $ 
C $Log: lxscnp.f,v $
C Revision 1.1  2009/06/10 18:23:54  gdsjaar
C Open source and copyright assertion
C
C Title:	SVDI Ver. 1.1
C SCR#:	126.2
C Type:	Open Source Software
C
C The Department of Energy (DOE), by memo dated 06/10/2009, has granted
C Sandia permission to assert its copyright in software entitled "SVDI
C Ver. 1.1".
C
C In accordance with the DOE's permission:
C
C All copies of "SVDI Ver. 1.1" that are released under an Open Source
C Software (OSS) license should be marked: Copyright (year first
C published) Sandia Corporation. Under the terms of Contract
C DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains
C certain rights in this software.
C
C The above notice should appear before the OSS license, and the above
C notice and the OSS license are the ONLY terms that should appear in
C the software or the associated web site. No other disclaimers or
C notices should be used.
C
C The primary vehicle for distribution of "SVDI Ver. 1.1" should be the
C OSS license and associated web site. However, if "SVDI Ver. 1.1" is to
C be released without an OSS license it should be marked: Copyright
C (year first published) Sandia Corporation. Under the terms of Contract
C DE-AC04-94AL85000, there is a non-exclusive license for use of this
C work by or on behalf of the U.S. Government. Export of this program
C may require a license from the United States Government.
C
C At a minimum, this copyright notice should be on the package
C containing the program. Preferably, the copyright notice should also
C be incorporated into the source code and be displayed on at least the
C first screen that comes up when the software is run. In addition, the
C following complete language should also be included in the copyright
C notice:
C
C NOTICE:
C
C 	For five (5) years from 06/10/2009, the United States
C 	Government is granted for itself and others acting on its
C 	behalf a paid-up, nonexclusive, irrevocable worldwide license
C 	in this data to reproduce, prepare derivative works, and
C 	perform publicly and display publicly, by or on behalf of the
C 	Government. There is provision for the possible extension of
C 	the term of this license. Subsequent to that period or any
C 	extension granted, the United States Government is granted for
C 	itself and others acting on its behalf a paid-up,
C 	nonexclusive, irrevocable worldwide license in this data to
C 	reproduce, prepare derivative works, distribute copies to the
C 	public, perform publicly and siplay publicly, and to permit
C 	others to do so. The specific term of the license can be
C 	identified by inquiry made to Sandia Corportation or DOE.
C
C 	NEITHER THE UNITED STATES GOVERNMENT, NOR THE UNITED STATES
C 	DEPARTMENT OF ENERGY, NOR SANDIA CORPORATION, NOR ANY OF THEIR
C 	EMPLOYEES, MAKES ANY WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES
C 	ANY LEGAL RESPONSIBILITY FOR THE ACCURACY, COMPLETENESS, OR
C 	USEFULNESS OF ANY INFORMATION, APPARATUS, PRODUCT, OR PROCESS
C 	DISCLOSED, OR REPRESENTS THAT ITS USE WOULD NOT INFRINGE
C 	PRIVATELY OWNED RIGHTS.
C
C 	Any licensee of this software has the obligation and
C 	responsibility to abide by the applicable export control laws,
C 	regulations, and general prohibitions relating to the export
C 	of technical data. Failure to obtain an export control license
C 	or other authority from the Government may result in criminal
C 	liability under U.S. laws.
C
C (End of Notice)
C
C This alternate language should only be used if the software is to be
C distributed without the OSS license. If there is any question at all
C as to which notice is appropriate, please contact Jason D. Martinez at
C (505) 844-8067.
C
C This software has been assigned SCR# 126.2. This number is a Sandia
C internal tracking number and is a useful reference when contacting the
C Intellectual Property Center or Licensing and IP Management. However,
C since this software is to be released as OSS, the software is deemed
C to be Publicly Available.
C
C Revision 1.1  1993/07/16 16:46:50  gdsjaar
C Changed plt to library rather than single source file.
C 
C=======================================================================
      LOGICAL FUNCTION LXSCNP(DELIM,STR,NS,CH)
      IMPLICIT INTEGER (A-Z)
      CHARACTER*504 ILINE
      COMMON /LXCOM1/ILINE
      COMMON /LXCOM2/JLINE,LXINIT
      CHARACTER*(*) DELIM
      CHARACTER*(*) STR
      INTEGER NS
      CHARACTER CH
      LOGICAL QFLAG
      CHARACTER QCH

      NS = 0
      J = JLINE
      LP = 0
      QFLAG = .FALSE.
 2600 CONTINUE
      CH = ILINE(J:J)
      IF (LP.EQ.0) THEN
         ID = INDEX(DELIM,CH)
         IF (ID.GT.0) THEN
            GO TO 2620

         END IF

      END IF

      IF (.NOT.QFLAG) THEN
         IF (LP.EQ.0) THEN
            ID = INDEX(DELIM,CH)
            IF (ID.GT.0) THEN
               GO TO 2620

            END IF

         END IF

         IF (CH.EQ.CHAR(0)) THEN
            GO TO 2620

         ELSE IF (CH.EQ.'(' .OR. CH.EQ.'[' .OR. CH.EQ.'{') THEN
            LP = LP + 1

         ELSE IF (CH.EQ.')' .OR. CH.EQ.']' .OR. CH.EQ.'}') THEN
            LP = LP - 1

         ELSE IF (CH.EQ.'''' .OR. CH.EQ.'"' .OR. CH.EQ.CHAR(96)) THEN
            QFLAG = .TRUE.
            QCH = CH
         END IF

         IF (LP.LT.0) THEN
            GO TO 2620

         END IF

         NS = NS + 1
         STR(NS:NS) = CH

      ELSE
         NS = NS + 1
         STR(NS:NS) = CH
         IF (CH.EQ.CHAR(0)) THEN
            GO TO 2620

         ELSE IF (CH.EQ.QCH) THEN
            IF (CH.EQ.ILINE(J+1:J+1)) THEN
               NS = NS + 1
               STR(NS:NS) = CH
               J = J + 2
               GO TO 2610

            ELSE
               QFLAG = .FALSE.
            END IF

         END IF

      END IF

      J = J + 1
 2610 GO TO 2600

 2620 CONTINUE
      JLINE = J
      LXSCNP = ((LP.EQ.0) .AND. .NOT.QFLAG)
      RETURN

      END
