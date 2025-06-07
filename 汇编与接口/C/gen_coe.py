import re
import sys

# 解析 elf 文件需要导入的依赖库
# 安装 pyelftools 库
from elftools.elf.elffile import ELFFile

def gen_data_mem_coe(elf_path, data_mem_coe_path):
    with open(elf_path, 'rb') as file:
        # 创建 ELFFile 对象
        elf_file = ELFFile(file)
        # 各个节在数据内存中的偏移
        offset_map = {}
        # 遍历节区头入口
        for section in elf_file.iter_sections():
            # print('name:', section.name)
            # print('header', section.header)
            if section.name == '.rodata' or section.name == ".data" or section.name == ".sdata":
                offset_map[section.header['sh_addr']] = section.data()


        with open(data_mem_coe_path, "w") as data_mem_coe_file:
            data_mem_coe_file.write("memory_initialization_radix=16;\n")
            data_mem_coe_file.write("memory_initialization_vector=\n")
            sorted_offset_map = dict(sorted(offset_map.items()))
            total_offset = 0x10000
            for key, value in sorted_offset_map.items():
                if key != total_offset:
                    data_mem_coe_file.write(((key-total_offset) // 4)*"00000000,\n")
                total_offset = key + len(value)
                # print("%x %x %x"%(key, len(value), total_offset))
                
                content = []

                for i in range(0, len(value.hex()), 8):
                    word_content = value.hex()[i:i+8]
                    content.append("".join([word_content[6:8], word_content[4:6], word_content[2:4], word_content[0:2]])) 
                data_mem_coe_file.write(",\n".join(content)+",\n")
            data_mem_coe_file.write("00000000;\n")

if __name__ == "__main__":
    dump_file_path = sys.argv[1]
    inst_mem_coe_path = sys.argv[2]
    elf_path = sys.argv[3]
    data_mem_coe_path = sys.argv[4]

    with open(inst_mem_coe_path, "w") as inst_mem_coe_file:
        inst_mem_coe_file.write("memory_initialization_radix=16;\n")
        inst_mem_coe_file.write("memory_initialization_vector=\n")
        with open(dump_file_path, "r") as dump_file:
            for line in dump_file:
                res = re.search(r"([0-9a-f]+):\s+([0-9a-f]{8})", line)
                if res is not None:
                    inst_mem_coe_file.write(res.group().split(":\t")[1] + ",\n")

        inst_mem_coe_file.write("00000000;\n")

    gen_data_mem_coe(elf_path, data_mem_coe_path)
    