<#
.SYNOPSIS
   Determine if the processor has specific features/instruction sets.
.DESCRIPTION
   Applications binaries may be compiled to take advantage of specific features
   of a processor.  This function can identify and report back on the 
   availability of those features.  It does not identify whether the 
   operating system can take advantage of those features.

   To read about the features identified, see here:
   https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-isprocessorfeaturepresent
.OUTPUT
   Returns an object with feature names and a boolean for their availability.
.Example
   $Features = Get-ProcessorFeatures()
   if ($Features.AVX512F_INSTRUCTIONS) {
      Write-Host "This processor has AVX512 features."
   }
.NOTES
   Copyright 2026 Teknowledgist

   This script/information is free: you can redistribute 
   it and/or modify it under the terms of the GNU General Public License 
   as published by the Free Software Foundation, either version 2 of the 
   License, or (at your option) any later version.

   This script is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   The GNU General Public License can be found at <http://www.gnu.org/licenses/>.
#>

Function Get-ProcessorFeatures() {
   $Signature = @'
   [DllImport("Kernel32.dll")][return: MarshalAs(UnmanagedType.Bool)]
   public static extern bool IsProcessorFeaturePresent(
      uint ProcessorFeature
   );
'@
   $type = Add-Type -MemberDefinition $Signature -Name Win32Utils -Namespace GetProcessorFeatures -PassThru
   
   # https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-isprocessorfeaturepresent
   $FeatureIDs = [ordered]@{
      '0' = 'FLOATING_POINT_PRECISION_ERRATA' #On a Pentium, a floating-point precision error can occur in rare circumstances.   
      '1' = 'FLOATING_POINT_EMULATED' #Floating-point operations are emulated using a software emulator.   
      '2' = 'COMPARE_EXCHANGE_DOUBLE' #The atomic compare and exchange operation (cmpxchg) is available.   
      '3' = 'MMX_INSTRUCTIONS' #The MMX instruction set is available.   
      '6' = 'XMMI_INSTRUCTIONS' #The SSE instruction set is available.   
      '7' = '3DNOW_INSTRUCTIONS' #The 3D-Now instruction set is available.   
      '8' = 'RDTSC_INSTRUCTION' #The RDTSC instruction is available.   
      '9' = 'PAE_ENABLED' #The processor is Physical Address Extension (PAE)-enabled. All x64 processors always return a nonzero value for this feature.    
      '10' = 'XMMI64_INSTRUCTIONS' #The SSE2 instruction set is available. Windows 2000: Not supported.    
      '12' = 'NX_ENABLED' #Data execution prevention is enabled.  Windows XP/2000: Not supported.    
      '13' = 'SSE3_INSTRUCTIONS' #The SSE3 instruction set is available. Windows Server 2003 and Windows XP/2000: Not supported.    
      '14' = 'COMPARE_EXCHANGE128' #The  atomic compare and exchange 128-bit operation (cmpxchg16b) is available. Windows Server 2003 and Windows�XP/2000: Not supported.    
      '15' = 'COMPARE64_EXCHANGE128' #The atomic compare 64 and exchange 128-bit operation (cmp8xchg16) is available. Windows Server 2003 and Windows�XP/2000: Not supported.    
      '16' = 'CHANNELS_ENABLED' #The processor channels are enabled.   
      '17' = 'XSAVE_ENABLED' #The processor implements the XSAVE and XRSTOR instructions. Windows Server 2003/2008, Windows 2000/XP/Vista: Not supported.    
      '18' = 'ARM_VFP_32_REGISTERS' #The VFP/Neon: 32 x 64bit register bank is present. This flag has the same meaning as PF_ARM_VFP_EXTENDED_REGISTERS .   
      '20' = 'SECOND_LEVEL_ADDRESS_TRANSLATION' #Second Level Address Translation is supported by the hardware.   
      '21' = 'VIRT_FIRMWARE_ENABLED' #Virtualization is enabled in the firmware and made available by the operating system.   
      '22' = 'RDWRFSGSBASE' #RDFSBASE, RDGSBASE, WRFSBASE, and WRGSBASE instructions are available.   
      '23' = 'FASTFAIL' #_fastfail() is available.   
      '24' = 'ARM_DIVIDE_INSTRUCTION' #The divide instructions are available.   
      '25' = 'ARM_64BIT_LOADSTORE_ATOMIC' #The 64-bit load/store atomic instructions are available.   
      '26' = 'ARM_EXTERNAL_CACHE' #The external cache is available.   
      '27' = 'ARM_FMAC_INSTRUCTIONS' #The floating-point multiply-accumulate instruction is available.   
      '29' = 'ARM_V8_INSTRUCTIONS' #This Arm processor implements the Arm v8 instructions set.   
      '30' = 'ARM_V8_CRYPTO_INSTRUCTIONS' #This Arm processor implements the Arm v8 extra cryptographic instructions (for example, AES, SHA1 and SHA2).   
      '31' = 'ARM_V8_CRC32_INSTRUCTIONS' #This Arm processor implements the Arm v8 extra CRC32 instructions.   
      '34' = 'ARM_V81_ATOMIC_INSTRUCTIONS' #This Arm processor implements the Arm v8.1 atomic instructions (for example, CAS, SWP).   
      '36' = 'SSSE3_INSTRUCTIONS' #The SSSE3 instruction set is available.   
      '37' = 'SSE4_1_INSTRUCTIONS' #The SSE4_1 instruction set is available.   
      '38' = 'SSE4_2_INSTRUCTIONS' #The SSE4_2 instruction set is available.   
      '39' = 'AVX_INSTRUCTIONS' #The AVX instruction set is available.   
      '40' = 'AVX2_INSTRUCTIONS' #The AVX2 instruction set is available.   
      '41' = 'AVX512F_INSTRUCTIONS' #The AVX512F instruction set is available.   
      '43' = 'ARM_V82_DP_INSTRUCTIONS' #This Arm processor implements the Arm v8.2 DP instructions (for example, SDOT, UDOT). This feature is optional in Arm v8.2 implementations and mandatory in Arm v8.4 implementations.   
      '44' = 'ARM_V83_JSCVT_INSTRUCTIONS' #This Arm processor implements the Arm v8.3 JSCVT instructions (for example, FJCVTZS).   
      '45' = 'ARM_V83_LRCPC_INSTRUCTIONS' #This Arm processor implements the Arm v8.3 LRCPC instructions (for example, LDAPR). Note that certain Arm v8.2 CPUs may optionally support the LRCPC instructions.   
      '46' = 'PF_ARM_SVE_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE (Scalable Vector Extension) instructions (FEAT_SVE).
      '47' = 'PF_ARM_SVE2_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE2 instructions (FEAT_SVE2).
      '48' = 'PF_ARM_SVE2_1_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE2.1 instructions (FEAT_SVE2p1).
      '49' = 'PF_ARM_SVE_AES_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE AES instructions (FEAT_SVE_AES).
      '50' = 'PF_ARM_SVE_PMULL128_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE 128-bit polynomial multiply long instructions (FEAT_SVE_PMULL128).
      '51' = 'PF_ARM_SVE_BITPERM_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE bit permute instructions (FEAT_SVE_BitPerm).
      '52' = 'PF_ARM_SVE_BF16_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE BF16 (BFloat16) instructions (FEAT_BF16).
      '53' = 'PF_ARM_SVE_EBF16_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE EBF16 (Extended BFloat16) instructions (FEAT_EBF16).
      '54' = 'PF_ARM_SVE_B16B16_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE B16B16 instructions (FEAT_SVE_B16B16).
      '55' = 'PF_ARM_SVE_SHA3_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE SHA-3 cryptographic instructions (FEAT_SVE_SHA3).
      '56' = 'PF_ARM_SVE_SM4_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE SM4 cryptographic instructions (FEAT_SVE_SM4).
      '57' = 'PF_ARM_SVE_I8MM_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE I8MM (Int8 matrix multiply) instructions (FEAT_I8MM).
      '58' = 'PF_ARM_SVE_F32MM_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE F32MM (FP32 matrix multiply) instructions (FEAT_F32MM).
      '59' = 'PF_ARM_SVE_F64MM_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE F64MM (FP64 matrix multiply) instructions (FEAT_F64MM).
      '60' = 'PF_BMI2_INSTRUCTIONS_AVAILABLE' #This x64 processor implements the BMI2 instruction set.
      '61' = 'PF_MOVDIR64B_INSTRUCTION_AVAILABLE' #This x64 processor implements the MOVDIR64B instruction.
      '62' = 'PF_ARM_LSE2_AVAILABLE' #This Arm processor implements the LSE2 atomic instructions (FEAT_LSE2).
      '64' = 'PF_ARM_SHA3_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SHA-3 cryptographic instructions (FEAT_SHA3).
      '65' = 'PF_ARM_SHA512_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SHA-512 cryptographic instructions (FEAT_SHA512).
      '66' = 'PF_ARM_V82_I8MM_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the I8MM (Int8 matrix multiply) NEON instructions (FEAT_I8MM).
      '67' = 'PF_ARM_V82_FP16_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the FP16 (half-precision floating point) NEON instructions (FEAT_FP16).
      '68' = 'PF_ARM_V86_BF16_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the BF16 (BFloat16) NEON instructions (FEAT_BF16).
      '69' = 'PF_ARM_V86_EBF16_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the EBF16 (Extended BFloat16) NEON instructions (FEAT_EBF16).
      '70' = 'PF_ARM_SME_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SME (Scalable Matrix Extension) instructions (FEAT_SME).
      '71' = 'PF_ARM_SME2_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SME2 instructions (FEAT_SME2).
      '72' = 'PF_ARM_SME2_1_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SME2.1 instructions (FEAT_SME2p1).
      '73' = 'PF_ARM_SME2_2_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SME2.2 instructions (FEAT_SME2p2).
      '74' = 'PF_ARM_SME_AES_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE AES instructions when in Streaming SVE mode (FEAT_SSVE_AES).
      '75' = 'PF_ARM_SME_SBITPERM_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE bit permute instructions when in Streaming SVE mode (FEAT_SSVE_BitPerm).
      '76' = 'PF_ARM_SME_SF8MM4_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE FMMLA (widening, 4-way, FP8 to FP16) instruction when in Streaming SVE mode (FEAT_SSVE_F8F16MM).
      '77' = 'PF_ARM_SME_SF8MM8_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE FMMLA (widening, 8-way, FP8 to FP32) instruction when in Streaming SVE mode (FEAT_SSVE_F8F32MM).
      '78' = 'PF_ARM_SME_SF8DP2_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE2 FP8DOT2 instructions when in Streaming SVE mode (FEAT_SSVE_FP8DOT2).
      '79' = 'PF_ARM_SME_SF8DP4_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE2 FP8DOT4 instructions when in Streaming SVE mode (FEAT_SSVE_FP8DOT4).
      '80' = 'PF_ARM_SME_SF8FMA_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SVE2 FP8FMA instructions when in Streaming SVE mode (FEAT_SSVE_FP8FMA).
      '81' = 'PF_ARM_SME_F8F32_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SME F8F32 instructions (FEAT_SME_F8F32).
      '82' = 'PF_ARM_SME_F8F16_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SME F8F16 instructions (FEAT_SME_F8F16).
      '83' = 'PF_ARM_SME_F16F16_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SME F16F16 instructions (FEAT_SME_F16F16).
      '84' = 'PF_ARM_SME_B16B16_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SME B16B16 instructions (FEAT_SME_B16B16).
      '85' = 'PF_ARM_SME_F64F64_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SME F64F64 instructions (FEAT_SME_F64F64).
      '86' = 'PF_ARM_SME_I16I64_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SME I16I64 instructions (FEAT_SME_I16I64).
      '87' = 'PF_ARM_SME_LUTv2_INSTRUCTIONS_AVAILABLE' #This Arm processor implements the SME LUTv2 instructions (FEAT_SME_LUTv2).
      '88' = 'PF_ARM_SME_FA64_INSTRUCTIONS_AVAILABLE' #This Arm processor implements SME FA64 (Full AArch64 instruction set when in Streaming SVE mode) (FEAT_SME_FA64).
      '89' = 'PF_UMONITOR_INSTRUCTION_AVAILABLE' #This x64 processor implements the UMONITOR instruction.
   }

   $Features = @{}
   Foreach ($ID in $FeatureIDs.keys) {
      $Features.Add($FeatureIDs["$ID"],$type::IsProcessorFeaturePresent($ID))
   }
   [PSCustomObject]$Features

}



