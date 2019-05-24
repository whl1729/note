# 《6.828 Lecture Notes: x86 and PC architecture》摘录笔记

原文链接：[6.828 Lecture Notes: x86 and PC architecture](https://pdos.csail.mit.edu/6.828/2017/lec/l-x86.html)

1. EIP寄存器的值可以被以下指令修改：CALL、RET、JMP和conditional jumps.

2. 段和段寄存器
    * CS - code segment, for fetches via IP
    * SS - stack segment, for load/store via SP and BP
    * DS - data segment, for load/store via other registers

3. x86 dictates that stack grows down:
```
    // what "pushl %eax" does: 
    subl $4, %esp 
    movl %eax, (%esp) 
    // what "popl %eax" does:
    movl (%esp), %eax 
    addl $4, %esp
    // what "call 0x12345" does:
    pushl %eip (*) 
    movl $0x12345, %eip (*) 
    // what "ret" does:
    popl %eip (*)
    // (*) Not real instructions
```

4. GCC dictates how the stack is used. Contract between caller and callee on x86:
    * at entry to a function (i.e. just after call):
        * %eip points at first instruction of function
        * %esp+4 points at first argument
        * %esp points at return address
    * after ret instruction:
        * %eip contains return address
        * %esp points at arguments pushed by caller
        * called function may have trashed arguments
        * %eax (and %edx, if return type is 64-bit) contains return value (or trash if function is void)
        * %eax, %edx (above), and %ecx may be trashed
        * %ebp, %ebx, %esi, %edi must contain contents from time of call
    * Terminology:
        * %eax, %ecx, %edx are "caller save" registers
        * %ebp, %ebx, %esi, %edi are "callee save" registers

5. Functions can do anything that doesn't violate contract. By convention, GCC does more:
    * each function has a stack frame marked by %ebp, %esp
```
		       +------------+   |
		       | arg 2      |   \
		       +------------+    >- previous function's stack frame
		       | arg 1      |   /
		       +------------+   |
		       | ret %eip   |   /
		       +============+   
		       | saved %ebp |   \
		%ebp-> +------------+   |
		       |            |   |
		       |   local    |   \
		       | variables, |    >- current function's stack frame
		       |    etc.    |   /
		       |            |   |
		       |            |   |
		%esp-> +------------+   /
```
    * %esp can move to make stack frame bigger, smaller
    * %ebp points at saved %ebp from previous function, chain to walk stack
    * function prologue:
```
    pushl %ebp
    movl %esp, %ebp
// or
    enter $0, $0
```
    enter usually not used: 4 bytes vs 3 for pushl+movl, not on hardware fast-path anymore
    * function epilogue can easily find return EIP on stack:
```
    movl %ebp, %esp
    popl %ebp		
or
    leave
```		
    leave used often because it's 1 byte, vs 3 for movl+popl		

6. Compiling, linking, loading:
    * Preprocessor takes C source code (ASCII text), expands #include etc, produces C source code
    * Compiler takes C source code (ASCII text), produces assembly language (also ASCII text)
    * Assembler takes assembly language (ASCII text), produces .o file (binary, machine-readable!)
    * Linker takes multiple '.o's, produces a single program image (binary)
    * Loader loads the program image into memory at run-time and starts it executing

## PC emulation

1. Stores emulated CPU registers in global variables
```
    int32_t regs[8];
    #define REG_EAX 1;
    #define REG_EBX 2;
    #define REG_ECX 3;
    ...
    int32_t eip;
    int16_t segregs[4];
```

2. Stores emulated physical memory in Boch's memory
```
    char mem[256*1024*1024];
```

3. Execute instructions by simulating them in a loop
```
	for (;;) {
		read_instruction();
		switch (decode_instruction_opcode()) {
		case OPCODE_ADD:
			int src = decode_src_reg();
			int dst = decode_dst_reg();
			regs[dst] = regs[dst] + regs[src];
			break;
		case OPCODE_SUB:
			int src = decode_src_reg();
			int dst = decode_dst_reg();
			regs[dst] = regs[dst] - regs[src];
			break;
		...
		}
		eip += instruction_length;
	}
```

4. Simulate PC's physical memory map by decoding emulated "physical" addresses just like a PC would:
```
	#define KB		1024
	#define MB		1024*1024

	#define LOW_MEMORY	640*KB
	#define EXT_MEMORY	10*MB

	uint8_t low_mem[LOW_MEMORY];
	uint8_t ext_mem[EXT_MEMORY];
	uint8_t bios_rom[64*KB];

	uint8_t read_byte(uint32_t phys_addr) {
		if (phys_addr < LOW_MEMORY)
			return low_mem[phys_addr];
		else if (phys_addr >= 960*KB && phys_addr < 1*MB)
			return rom_bios[phys_addr - 960*KB];
		else if (phys_addr >= 1*MB && phys_addr < 1*MB+EXT_MEMORY) {
			return ext_mem[phys_addr-1*MB];
		else ...
	}

	void write_byte(uint32_t phys_addr, uint8_t val) {
		if (phys_addr < LOW_MEMORY)
			low_mem[phys_addr] = val;
		else if (phys_addr >= 960*KB && phys_addr < 1*MB)
			; /* ignore attempted write to ROM! */
		else if (phys_addr >= 1*MB && phys_addr < 1*MB+EXT_MEMORY) {
			ext_mem[phys_addr-1*MB] = val;
		else ...
	}
```
