#!/bin/bash

# LaTeX编译脚本
# 使用方法: ./compile.sh [filename.tex] [选项]

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 函数定义
print_info() {
    echo -e "${BLUE}[信息]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[成功]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

print_error() {
    echo -e "${RED}[错误]${NC} $1"
}

show_help() {
    echo "LaTeX编译脚本"
    echo
    echo "使用方法:"
    echo "  $0 [filename.tex] [选项]"
    echo
    echo "选项:"
    echo "  -h, --help     显示此帮助信息"
    echo "  -c, --clean    编译前清理临时文件"
    echo "  -o, --open     编译后自动打开PDF"
    echo "  -q, --quiet    静默模式（不显示编译输出）"
    echo "  -b, --bibtex   包含bibtex编译步骤"
    echo
    echo "示例:"
    echo "  $0 homework.tex"
    echo "  $0 homework.tex --clean --open"
    echo "  $0 homework.tex -b -o"
}

# 默认参数
FILENAME=""
CLEAN=false
OPEN=false
QUIET=false
BIBTEX=false

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -o|--open)
            OPEN=true
            shift
            ;;
        -q|--quiet)
            QUIET=true
            shift
            ;;
        -b|--bibtex)
            BIBTEX=true
            shift
            ;;
        *.tex)
            FILENAME="$1"
            shift
            ;;
        *)
            print_error "未知选项: $1"
            show_help
            exit 1
            ;;
    esac
done

# 如果没有指定文件，尝试找到tex文件
if [ -z "$FILENAME" ]; then
    TEX_FILES=(*.tex)
    if [ ${#TEX_FILES[@]} -eq 1 ] && [ -f "${TEX_FILES[0]}" ]; then
        FILENAME="${TEX_FILES[0]}"
        print_info "自动选择文件: $FILENAME"
    else
        print_error "请指定要编译的.tex文件"
        echo
        print_info "当前目录的.tex文件:"
        ls -1 *.tex 2>/dev/null || echo "  (无.tex文件)"
        echo
        show_help
        exit 1
    fi
fi

# 检查文件是否存在
if [ ! -f "$FILENAME" ]; then
    print_error "文件不存在: $FILENAME"
    exit 1
fi

# 检查xelatex是否可用
if ! command -v xelatex &> /dev/null; then
    print_error "xelatex 未找到，请安装LaTeX发行版"
    print_info "Ubuntu/Debian: sudo apt install texlive-xetex"
    print_info "macOS: brew install mactex"
    exit 1
fi

# 获取不带扩展名的文件名
BASENAME=$(basename "$FILENAME" .tex)

# 清理临时文件
cleanup() {
    print_info "清理临时文件..."
    rm -f "${BASENAME}.aux" "${BASENAME}.log" "${BASENAME}.toc" \
          "${BASENAME}.out" "${BASENAME}.bbl" "${BASENAME}.blg" \
          "${BASENAME}.fls" "${BASENAME}.fdb_latexmk" "${BASENAME}.synctex.gz"
}

# 如果指定了清理选项，先清理
if [ "$CLEAN" = true ]; then
    cleanup
fi

print_info "开始编译 $FILENAME..."

# 设置编译输出
if [ "$QUIET" = true ]; then
    COMPILE_OUTPUT="/dev/null"
else
    COMPILE_OUTPUT="/dev/stdout"
fi

# 编译函数
compile_latex() {
    local pass_num=$1
    print_info "第${pass_num}次编译..."

    if [ "$QUIET" = true ]; then
        xelatex -interaction=nonstopmode "$FILENAME" > /dev/null 2>&1
    else
        xelatex -interaction=nonstopmode "$FILENAME"
    fi

    return $?
}

# 编译过程
compile_success=true

# 第一次编译
compile_latex 1
if [ $? -ne 0 ]; then
    print_error "第一次编译失败!"
    compile_success=false
fi

# 如果需要bibtex
if [ "$BIBTEX" = true ] && [ "$compile_success" = true ]; then
    if [ -f "${BASENAME}.aux" ] && grep -q "\\citation" "${BASENAME}.aux"; then
        print_info "运行 bibtex..."
        if [ "$QUIET" = true ]; then
            bibtex "$BASENAME" > /dev/null 2>&1
        else
            bibtex "$BASENAME"
        fi

        if [ $? -eq 0 ]; then
            # bibtex后需要再编译两次
            compile_latex 2
            if [ $? -ne 0 ]; then
                compile_success=false
            fi
        else
            print_warning "bibtex 执行失败，继续编译..."
        fi
    else
        print_info "未检测到引用，跳过 bibtex"
    fi
fi

# 第二次编译（生成目录和交叉引用）
if [ "$compile_success" = true ]; then
    compile_latex 2
    if [ $? -ne 0 ]; then
        compile_success=false
    fi
fi

# 检查编译结果
if [ "$compile_success" = true ]; then
    if [ -f "${BASENAME}.pdf" ]; then
        print_success "编译成功! 输出文件: ${BASENAME}.pdf"

        # 显示文件信息
        PDF_SIZE=$(du -h "${BASENAME}.pdf" | cut -f1)
        print_info "PDF文件大小: $PDF_SIZE"

        # 自动清理临时文件
        cleanup

        # 如果指定了打开选项，尝试打开PDF
        if [ "$OPEN" = true ]; then
            print_info "正在打开PDF文件..."

            if command -v xdg-open &> /dev/null; then
                xdg-open "${BASENAME}.pdf" 2>/dev/null &
            elif command -v open &> /dev/null; then
                # macOS
                open "${BASENAME}.pdf"
            elif command -v start &> /dev/null; then
                # Windows
                start "${BASENAME}.pdf"
            else
                print_warning "无法自动打开PDF，请手动打开: ${BASENAME}.pdf"
            fi
        fi

    else
        print_error "编译完成但未生成PDF文件"
        exit 1
    fi
else
    print_error "编译失败!"

    # 显示可能的错误信息
    if [ -f "${BASENAME}.log" ]; then
        print_info "查看错误信息:"
        echo "----------------------------------------"
        grep -A 5 -B 5 "^!" "${BASENAME}.log" | head -20
        echo "----------------------------------------"
        print_info "完整错误日志: ${BASENAME}.log"
    fi

    exit 1
fi

print_success "操作完成!"