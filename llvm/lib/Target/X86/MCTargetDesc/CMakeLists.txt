add_llvm_component_library(LLVMX86Desc
  X86ATTInstPrinter.cpp
  X86IntelInstPrinter.cpp
  X86InstComments.cpp
  X86InstPrinterCommon.cpp
  X86InstrRelaxTables.cpp
  X86ShuffleDecode.cpp
  X86AsmBackend.cpp
  X86MCTargetDesc.cpp
  X86MCAsmInfo.cpp
  X86MCCodeEmitter.cpp
  X86MachObjectWriter.cpp
  X86ELFObjectWriter.cpp
  X86WinCOFFObjectWriter.cpp
  X86WinCOFFStreamer.cpp
  X86WinCOFFTargetStreamer.cpp

  LINK_COMPONENTS
  MC
  MCDisassembler
  Support
  X86Info
  BinaryFormat

  ADD_TO_COMPONENT
  X86
  )
