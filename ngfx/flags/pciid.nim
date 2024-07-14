# This file is a part of NGfx. Copyright (C) 2024 carrexxii.
# It is distributed under the terms of the Apache License, Version 2.0.
# For a copy, see the LICENSE file or <https://apache.org/licenses/>.

type PCIIDFlag* = distinct uint16
func `$`*(a: PCIIDFlag): string {.borrow.}
const
    none*      = PCIIDFlag 0x0000
    software*  = PCIIDFlag 0x0001
    amd*       = PCIIDFlag 0x1002
    apple*     = PCIIDFlag 0x106B
    intel*     = PCIIDFlag 0x8086
    nvidia*    = PCIIDFlag 0x10DE
    microsoft* = PCIIDFlag 0x1414
    arm*       = PCIIDFlag 0x13B5

