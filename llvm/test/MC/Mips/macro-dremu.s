# RUN: llvm-mc %s -triple=mips64el-unknown-linux -show-encoding -mcpu=mips64 | \
# RUN:   FileCheck %s --check-prefix=CHECK-NOTRAP
# RUN: llvm-mc %s -triple=mips64el-unknown-linux -show-encoding -mcpu=mips64 \
# RUN:  -mattr=+use-tcc-in-div | FileCheck %s --check-prefix=CHECK-TRAP

  dremu $4,$5
# CHECK-NOTRAP: bne $5, $zero, .Ltmp0     # encoding: [A,A,0xa0,0x14]
# CHECK-NOTRAP:                           # fixup A - offset: 0, value: .Ltmp0-4, kind: fixup_Mips_PC16
# CHECK-NOTRAP: ddivu $zero, $4, $5       # encoding: [0x1f,0x00,0x85,0x00]
# CHECK-NOTRAP: break 7                   # encoding: [0x0d,0x00,0x07,0x00]
# CHECK-NOTRAP: .Ltmp0
# CHECK-NOTRAP: mfhi $4                   # encoding: [0x10,0x20,0x00,0x00]
# CHECK-TRAP: teq $5, $zero, 7            # encoding: [0xf4,0x01,0xa0,0x00]
# CHECK-TRAP: ddivu $zero, $4, $5         # encoding: [0x1f,0x00,0x85,0x00]
# CHECK-TRAP: mfhi $4                     # encoding: [0x10,0x20,0x00,0x00]

  dremu $4,$0
# CHECK-NOTRAP: break 7                   # encoding: [0x0d,0x00,0x07,0x00]
# CHECK-TRAP: teq $zero, $zero, 7         # encoding: [0xf4,0x01,0x00,0x00]

  dremu $4,0
# CHECK-NOTRAP: break 7                   # encoding: [0x0d,0x00,0x07,0x00]
# CHECK-TRAP: teq $zero, $zero, 7         # encoding: [0xf4,0x01,0x00,0x00]

  dremu $0,0
# CHECK-NOTRAP: break 7                   # encoding: [0x0d,0x00,0x07,0x00]
# CHECK-TRAP: teq $zero, $zero, 7         # encoding: [0xf4,0x01,0x00,0x00]

  dremu $4,1
# CHECK-NOTRAP: or $4, $zero, $zero       # encoding: [0x25,0x20,0x00,0x00]
# CHECK-TRAP: or $4, $zero, $zero         # encoding: [0x25,0x20,0x00,0x00]

  dremu $4,2
# CHECK-NOTRAP: addiu $1, $zero, 2        # encoding: [0x02,0x00,0x01,0x24]
# CHECK-NOTRAP: ddivu $zero, $4, $1       # encoding: [0x1f,0x00,0x81,0x00]
# CHECK-NOTRAP: mfhi $4                   # encoding: [0x10,0x20,0x00,0x00]
# CHECK-TRAP: addiu $1, $zero, 2          # encoding: [0x02,0x00,0x01,0x24]
# CHECK-TRAP: ddivu $zero, $4, $1         # encoding: [0x1f,0x00,0x81,0x00]
# CHECK-TRAP: mfhi $4                     # encoding: [0x10,0x20,0x00,0x00]

  dremu $4,-1
# CHECK-NOTRAP: addiu $1, $zero, -1       # encoding: [0xff,0xff,0x01,0x24]
# CHECK-NOTRAP: ddivu $zero, $4, $1       # encoding: [0x1f,0x00,0x81,0x00]
# CHECK-NOTRAP: mfhi $4                   # encoding: [0x10,0x20,0x00,0x00]
# CHECK-TRAP: addiu $1, $zero, -1         # encoding: [0xff,0xff,0x01,0x24]
# CHECK-TRAP: ddivu $zero, $4, $1         # encoding: [0x1f,0x00,0x81,0x00]
# CHECK-TRAP: mfhi $4                     # encoding: [0x10,0x20,0x00,0x00]

  dremu $4,0x1a5a5
# CHECK-NOTRAP: lui $1, 1                 # encoding: [0x01,0x00,0x01,0x3c]
# CHECK-NOTRAP: ori $1, $1, 42405         # encoding: [0xa5,0xa5,0x21,0x34]
# CHECK-NOTRAP: ddivu $zero, $4, $1       # encoding: [0x1f,0x00,0x81,0x00]
# CHECK-NOTRAP: mfhi $4                   # encoding: [0x10,0x20,0x00,0x00]
# CHECK-TRAP: lui $1, 1                   # encoding: [0x01,0x00,0x01,0x3c]
# CHECK-TRAP: ori $1, $1, 42405           # encoding: [0xa5,0xa5,0x21,0x34]
# CHECK-TRAP: ddivu $zero, $4, $1         # encoding: [0x1f,0x00,0x81,0x00]
# CHECK-TRAP: mfhi $4                     # encoding: [0x10,0x20,0x00,0x00]

  dremu $4,0x10000
# CHECK-NOTRAP: lui $1, 1                 # encoding: [0x01,0x00,0x01,0x3c]
# CHECK-NOTRAP: ddivu $zero, $4, $1       # encoding: [0x1f,0x00,0x81,0x00]
# CHECK-NOTRAP: mfhi $4                   # encoding: [0x10,0x20,0x00,0x00]
# CHECK-TRAP: lui $1, 1                   # encoding: [0x01,0x00,0x01,0x3c]
# CHECK-TRAP: ddivu $zero, $4, $1         # encoding: [0x1f,0x00,0x81,0x00]
# CHECK-TRAP: mfhi $4                     # encoding: [0x10,0x20,0x00,0x00]

  dremu $4,-0x8000
# CHECK-NOTRAP: addiu $1, $zero, -32768   # encoding: [0x00,0x80,0x01,0x24]
# CHECK-NOTRAP: ddivu $zero, $4, $1       # encoding: [0x1f,0x00,0x81,0x00]
# CHECK-NOTRAP: mfhi $4                   # encoding: [0x10,0x20,0x00,0x00]
# CHECK-TRAP: addiu $1, $zero, -32768     # encoding: [0x00,0x80,0x01,0x24]
# CHECK-TRAP: ddivu $zero, $4, $1         # encoding: [0x1f,0x00,0x81,0x00]
# CHECK-TRAP: mfhi $4                     # encoding: [0x10,0x20,0x00,0x00]

  dremu $4,0x8000
# CHECK-NOTRAP: ori $1, $zero, 32768      # encoding: [0x00,0x80,0x01,0x34]
# CHECK-NOTRAP: ddivu $zero, $4, $1       # encoding: [0x1f,0x00,0x81,0x00]
# CHECK-NOTRAP: mfhi $4                   # encoding: [0x10,0x20,0x00,0x00]
# CHECK-TRAP: ori $1, $zero, 32768        # encoding: [0x00,0x80,0x01,0x34]
# CHECK-TRAP: ddivu $zero, $4, $1         # encoding: [0x1f,0x00,0x81,0x00]
# CHECK-TRAP: mfhi $4                     # encoding: [0x10,0x20,0x00,0x00]

  dremu $4,$5,$6
# CHECK-NOTRAP: bne $6, $zero, .Ltmp1     # encoding: [A,A,0xc0,0x14]
# CHECK-NOTRAP:                           # fixup A - offset: 0, value: .Ltmp1-4, kind: fixup_Mips_PC16
# CHECK-NOTRAP: ddivu $zero, $5, $6       # encoding: [0x1f,0x00,0xa6,0x00]
# CHECK-NOTRAP: break 7                   # encoding: [0x0d,0x00,0x07,0x00]
# CHECK-NOTRAP: .Ltmp1
# CHECK-NOTRAP: mfhi $4                   # encoding: [0x10,0x20,0x00,0x00]
# CHECK-TRAP: teq $6, $zero, 7            # encoding: [0xf4,0x01,0xc0,0x00]
# CHECK-TRAP: ddivu $zero, $5, $6         # encoding: [0x1f,0x00,0xa6,0x00]
# CHECK-TRAP: mfhi $4                     # encoding: [0x10,0x20,0x00,0x00]

  dremu $4,$5,$0
# CHECK-NOTRAP: break 7                   # encoding: [0x0d,0x00,0x07,0x00]
# CHECK-TRAP: teq $zero, $zero, 7         # encoding: [0xf4,0x01,0x00,0x00]

  dremu $4,$0,$0
# CHECK-NOTRAP: break 7                   # encoding: [0x0d,0x00,0x07,0x00]
# CHECK-TRAP: teq $zero, $zero, 7         # encoding: [0xf4,0x01,0x00,0x00]

  dremu $0,$4,$5
# CHECK-NOTRAP: ddivu $zero, $4, $5       # encoding: [0x1f,0x00,0x85,0x00]
# CHECK-TRAP: ddivu $zero, $4, $5         # encoding: [0x1f,0x00,0x85,0x00]

  dremu $0,$5,$4
# CHECK-NOTRAP: ddivu $zero, $5, $4       # encoding: [0x1f,0x00,0xa4,0x00]
# CHECK-TRAP: ddivu $zero, $5, $4         # encoding: [0x1f,0x00,0xa4,0x00]

  dremu $4,$5,0
# CHECK-NOTRAP: break 7                   # encoding: [0x0d,0x00,0x07,0x00]
# CHECK-TRAP: teq $zero, $zero, 7         # encoding: [0xf4,0x01,0x00,0x00]

  dremu $4,$0,0
# CHECK-NOTRAP: break 7                   # encoding: [0x0d,0x00,0x07,0x00]
# CHECK-TRAP: teq $zero, $zero, 7         # encoding: [0xf4,0x01,0x00,0x00]

  dremu $4,$5,1
# CHECK-NOTRAP: or $4, $zero, $zero       # encoding: [0x25,0x20,0x00,0x00]
# CHECK-TRAP: or $4, $zero, $zero         # encoding: [0x25,0x20,0x00,0x00]

  dremu $4,$5,-1
# CHECK-NOTRAP: addiu $1, $zero, -1       # encoding: [0xff,0xff,0x01,0x24]
# CHECK-NOTRAP: ddivu $zero, $5, $1       # encoding: [0x1f,0x00,0xa1,0x00]
# CHECK-NOTRAP: mfhi $4                   # encoding: [0x10,0x20,0x00,0x00]
# CHECK-TRAP: addiu $1, $zero, -1         # encoding: [0xff,0xff,0x01,0x24]
# CHECK-TRAP: ddivu $zero, $5, $1         # encoding: [0x1f,0x00,0xa1,0x00]
# CHECK-TRAP: mfhi $4                     # encoding: [0x10,0x20,0x00,0x00]

  dremu $4,$5,2
# CHECK-NOTRAP: addiu $1, $zero, 2        # encoding: [0x02,0x00,0x01,0x24]
# CHECK-NOTRAP: ddivu $zero, $5, $1       # encoding: [0x1f,0x00,0xa1,0x00]
# CHECK-NOTRAP: mfhi $4                   # encoding: [0x10,0x20,0x00,0x00]
# CHECK-TRAP: addiu $1, $zero, 2          # encoding: [0x02,0x00,0x01,0x24]
# CHECK-TRAP: ddivu $zero, $5, $1         # encoding: [0x1f,0x00,0xa1,0x00]
# CHECK-TRAP: mfhi $4                     # encoding: [0x10,0x20,0x00,0x00]
