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
- **快速配置**：修改几个参数即可适配任何课程
- **标准化答题**：`\answerbox{}`统一答题格式
- **丰富示例**：包含各种常用元素的使用示例
- **自动编号**：公式、图表、章节自动编号和交叉引用

### 🔧 高度定制
- **模块化设计**：可根据需要启用/禁用功能
- **多种样式**：支持不同的代码风格和颜色主题
- **灵活布局**：可调整页面布局、字体大小等

## 快速开始

### 1. 复制模板
```bash
cp ~/.latex_templates/universal_homework.tex your_homework.tex
```

### 2. 配置基本信息
在模板文件开头修改以下参数：
```latex
\newcommand{\coursename}{计算机视觉}      % 课程名称
\newcommand{\hwnum}{1}                    % 作业编号
\newcommand{\studentname}{张三}           % 姓名
\newcommand{\studentid}{2021000000}       % 学号
\newcommand{\department}{信息科学技术学院} % 院系
\newcommand{\semester}{2025年秋季学期}    % 学期
```

### 3. 编译
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

### 编译命令
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

该模板位于 `~/.latex_templates/` 目录下，包含：
- `universal_homework.tex` - 主模板文件
- `README.md` - 本说明文档

建议定期备份和更新模板以获得更好的功能和修复。

## 联系和反馈

如果在使用过程中遇到问题或有改进建议，欢迎反馈！

---
*祝你的作业写作顺利！📚*