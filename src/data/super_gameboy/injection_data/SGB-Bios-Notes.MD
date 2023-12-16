SNES inputs written to:
    P1 - $000f11
    P2 - $000f13


SNES writes to BG Here?
   00BAA7: JSR $BC7F ; [SendInputsToGB]
    That's rom, can't patch
    However, call before is to 0808
        Which is an immediate return
        Could hook into here, and then jump back to [BAAA], skipping the native [SendInputsToGB[


We can patch into 0808

00BAA4: JSR $0808 ; [SendInputsToGB]
    000808: RTS 
00BAA7: JSR $BC7F ; [SendInputsToGB]
00BAAA: JSR $BC2C


RTS Opcode
    PC.l ← [S+1]
    PC.h ← [S+2]
    S    ← S + 2
    PC   ← PC + 1

To change the return address, pop 2 off stack, push new byes...