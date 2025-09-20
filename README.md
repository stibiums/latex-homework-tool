# 北大通用LaTeX作业模板

## 简介

这是一个专为北京大学各类课程作业设计的通用LaTeX模板，支持数学、物理、计算机、工程等各个学科的作业需求。

## 特性

### ✨ 功能完整
- **中文支持**：完美的中文排版
- **数学公式**：支持复杂数学推导和符号
- **多语言代码**：Python、C++、Matlab等代码高亮
- **图表支持**：单图、子图、表格、流程图
- **定理环境**：定理、引理、定义、例子等
- **专业排版**：符合学术规范

### 🎯 易于使用
- **一键安装**：自动配置命令别名和快捷方式
- **快速创建**：交互式作业创建，自动配置学生信息
- **智能编译**：支持多种编译选项，自动处理临时文件
- **标准化答题**：`\answerbox{}`统一答题格式
- **丰富示例**：包含各种常用元素的使用示例
- **自动编号**：公式、图表、章节自动编号和交叉引用

### 🔧 高度定制
- **模块化设计**：可根据需要启用/禁用功能
- **多种样式**：支持不同的代码风格和颜色主题
- **灵活布局**：可调整页面布局、字体大小等

## 安装和设置

### 一键安装（推荐）
```bash
cd ~/.latex_templates
./install.sh
```

安装脚本会自动：
- 为你的shell添加便捷命令别名
- 创建桌面快捷方式（Linux）
- 配置快速访问命令

安装完成后，重启终端或运行 `source ~/.bashrc`（或对应的shell配置文件）。

### 可用命令
安装后你可以使用以下便捷命令：

```bash
# 快速创建作业（交互式）
create-homework 课程名 作业号 [目标目录]

# 编译LaTeX文件
compile-latex 文件名.tex [选项]

# 快速模板创建函数
latex-template 课程名 作业号 [目标目录]

# 快速编译函数
latex-compile 文件名.tex [选项]

# 查看帮助文档
latex-help
```

## 快速开始

### 方法一：使用便捷命令（推荐）
```bash
# 创建新作业（会自动提示输入学生信息）
create-homework 计算机视觉 1

# 或指定目标目录
create-homework 数学分析 2 ~/Documents/homework/
```

### 方法二：手动复制模板
```bash
cp ~/.latex_templates/universal_homework.tex your_homework.tex
```

然后手动配置基本信息：
```latex
\newcommand{\coursename}{计算机视觉}      % 课程名称
\newcommand{\hwnum}{1}                    % 作业编号
\newcommand{\studentname}{张三}           % 姓名
\newcommand{\studentid}{2021000000}       % 学号
\newcommand{\department}{信息科学技术学院} % 院系
\newcommand{\semester}{2025年秋季学期}    % 学期
```

### 编译选项

#### 使用编译脚本（推荐）
```bash
# 基本编译
compile-latex homework.tex

# 编译前清理临时文件
compile-latex homework.tex --clean

# 编译后自动打开PDF
compile-latex homework.tex --open

# 包含参考文献处理
compile-latex homework.tex --bibtex

# 静默模式
compile-latex homework.tex --quiet

# 组合使用
compile-latex homework.tex -c -o -b
```

#### 手动编译
```bash
xelatex your_homework.tex
xelatex your_homework.tex  # 第二次编译生成目录和交叉引用
```

## 使用指南

### 📝 基本写作

#### 答题区域
```latex
\answerbox{
在这里写你的答案
支持数学公式：$x = \frac{a}{b}$
支持多行内容和复杂格式
}
```

#### 数学公式
```latex
% 行内公式
在文字中插入公式 $E = mc^2$ 继续文字

% 独立公式
\begin{equation}
x = \frac{-b \pm \sqrt{b^2-4ac}}{2a}
\label{eq:quadratic}
\end{equation}

% 多行对齐
\begin{align}
f(x) &= ax^2 + bx + c \\
f'(x) &= 2ax + b
\end{align}
```

#### 图片插入
```latex
% 单张图片
\begin{figure}[H]
    \centering
    \includegraphics[width=0.8\textwidth]{image.jpg}
    \caption{图片说明}
    \label{fig:myimage}
\end{figure}

% 引用图片
如图 \ref{fig:myimage} 所示...
```

#### 代码块
```latex
% Python代码
\begin{lstlisting}[style=pythonstyle, caption=Python代码示例]
def hello_world():
    print("Hello, World!")
\end{lstlisting}

% C++代码
\begin{lstlisting}[style=cppstyle, caption=C++代码示例]
#include <iostream>
int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
\end{lstlisting}
```

### 🎨 高级功能

#### 子图
```latex
\begin{figure}[H]
    \centering
    \begin{subfigure}{0.45\textwidth}
        \includegraphics[width=\textwidth]{image1.jpg}
        \caption{子图1}
    \end{subfigure}
    \hfill
    \begin{subfigure}{0.45\textwidth}
        \includegraphics[width=\textwidth]{image2.jpg}
        \caption{子图2}
    \end{subfigure}
    \caption{对比图}
\end{figure}
```

#### 表格
```latex
\begin{table}[H]
\centering
\caption{实验结果}
\begin{tabular}{|c|c|c|}
\hline
\textbf{方法} & \textbf{准确率} & \textbf{运行时间} \\
\hline
方法A & 95.2\% & 0.15s \\
方法B & 97.1\% & 0.23s \\
\hline
\end{tabular}
\label{tab:results}
\end{table}
```

#### 定理环境
```latex
\begin{definition}
定义内容...
\end{definition}

\begin{theorem}
定理内容...
\end{theorem}

\begin{example}
例子内容...
\end{example}
```

### 🎯 实用技巧

#### 数学符号
```latex
\vect{v}        % 向量（粗体）
\mat{A}         % 矩阵（粗体）
\bm{\alpha}     % 希腊字母粗体
```

#### 特殊标记
```latex
\important{重要内容}  % 红色加粗
\note{注意事项}       % 橙色注释
\hint{提示信息}       % 蓝色提示
```

#### 列表
```latex
\begin{enumerate}
    \item 有序列表项1
    \item 有序列表项2
\end{enumerate}

\begin{itemize}
    \item 无序列表项1
    \item 无序列表项2
\end{itemize}
```

## 不同课程的适配

### 数学课程
```latex
\newcommand{\coursename}{数学分析}
% 大量使用定理环境和数学公式
```

### 物理课程
```latex
\newcommand{\coursename}{理论力学}
% 使用物理符号和单位
\usepackage{siunitx}  % 添加单位支持
```

### 计算机课程
```latex
\newcommand{\coursename}{算法设计与分析}
% 使用算法环境和代码块
\usepackage{algorithm2e}  % 更高级的算法环境
```

### 工程课程
```latex
\newcommand{\coursename}{信号与系统}
% 使用电路图和信号图
\usepackage{circuitikz}  % 电路图支持
```

## 编译要求

### 必需软件
- **TeX发行版**：TeX Live (Linux/Mac) 或 MiKTeX (Windows)
- **编译器**：XeLaTeX（支持中文）
- **编辑器**：推荐 TeXstudio、VS Code + LaTeX Workshop、或 Overleaf

### 快速安装LaTeX环境
```bash
# Ubuntu/Debian
sudo apt install texlive-full

# 或最小安装
sudo apt install texlive-xetex texlive-latex-extra texlive-fonts-recommended

# macOS (需要先安装Homebrew)
brew install mactex
```

### 编译命令

#### 使用脚本编译（推荐）
```bash
# 查看编译脚本帮助
compile-latex --help

# 基本编译
compile-latex homework.tex

# 高级选项
compile-latex homework.tex --clean --open --bibtex
```

#### 手动编译
```bash
# 标准编译
xelatex homework.tex
xelatex homework.tex

# 如果有参考文献
xelatex homework.tex
bibtex homework
xelatex homework.tex
xelatex homework.tex
```

## 故障排除

### 常见问题

#### 1. 中文不显示
**原因**：使用了pdfLaTeX而不是XeLaTeX
**解决**：确保使用XeLaTeX编译

#### 2. 图片无法显示
**原因**：图片路径错误或格式不支持
**解决**：
- 检查文件路径
- 使用JPG、PNG、PDF格式
- 文件名不要包含中文和空格

#### 3. 代码块不高亮
**原因**：listings包设置问题
**解决**：确保使用正确的style参数

#### 4. 公式编译错误
**原因**：数学符号或环境使用错误
**解决**：
- 检查括号配对
- 确保在数学环境中使用数学符号
- 特殊字符需要转义

#### 5. 包找不到
**原因**：LaTeX发行版不完整
**解决**：
```bash
# Ubuntu/Debian
sudo apt install texlive-full

# 或手动安装特定包
tlmgr install package_name
```

#### 6. 命令别名不工作
**原因**：未正确加载shell配置或shell类型不支持
**解决**：
```bash
# 重新运行安装脚本
./install.sh

# 或手动重新加载配置
source ~/.bashrc  # 或 ~/.zshrc
```

#### 7. 脚本权限错误
**原因**：脚本文件没有执行权限
**解决**：
```bash
chmod +x ~/.latex_templates/*.sh
```

#### 8. 编译脚本找不到tex文件
**原因**：当前目录没有tex文件或文件名不正确
**解决**：
- 确保在包含tex文件的目录中运行
- 使用 `compile-latex filename.tex` 指定文件名
- 检查文件名是否正确

## 自定义和扩展

### 添加新的代码语言
```latex
\lstdefinestyle{javascriptstyle}{
    language=JavaScript,
    % 其他设置...
}
```

### 修改颜色主题
```latex
\definecolor{myblue}{RGB}{0,102,204}
\hypersetup{linkcolor=myblue}
```

### 添加新命令
```latex
\newcommand{\mycommand}[1]{\textbf{#1}}
```

## 模板维护

### 文件结构
该模板位于 `~/.latex_templates/` 目录下，包含：

```
~/.latex_templates/
├── universal_homework.tex   # 主模板文件
├── README.md               # 本说明文档
├── install.sh              # 安装脚本（配置命令别名）
├── create_homework.sh      # 快速创建作业脚本
└── compile.sh              # 智能编译脚本
```

### 自动化工具功能

#### `install.sh` - 安装脚本
- 自动检测shell类型（bash/zsh/fish）
- 添加便捷命令别名到对应配置文件
- 创建桌面快捷方式（Linux系统）
- 支持命令更新和重复安装

#### `create_homework.sh` - 作业创建脚本
- 交互式创建新作业文件
- 自动配置学生信息（支持从git配置读取）
- 智能文件命名：`课程名_作业号.tex`
- 可选择立即编译和打开PDF
- 支持自定义目标目录

#### `compile.sh` - 编译脚本
- 智能检测和选择tex文件
- 支持多种编译选项（清理、静默、bibtex等）
- 自动清理临时文件
- 跨平台PDF打开支持
- 详细的错误信息显示

### 备份和更新
建议定期备份模板目录：
```bash
# 备份整个模板目录
cp -r ~/.latex_templates ~/.latex_templates.backup.$(date +%Y%m%d)

# 或使用git管理（如果你fork了此项目）
cd ~/.latex_templates
git pull origin main
```

## 联系和反馈

如果在使用过程中遇到问题或有改进建议，欢迎反馈！

---
*祝你的作业写作顺利！📚*