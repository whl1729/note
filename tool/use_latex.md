# LaTeX使用笔记

## 常用技巧

1. 安装LaTeX：参考[Installing LaTeX on Ubuntu](https://dzone.com/articles/installing-latex-ubuntu).
```
sudo apt-get install texlive-full
sudo apt-get install texmaker
texmaker  // open texmaker
```

2. tex转pdf：`pdflatex /path/to/myfile.tex --output-directory=../otherdir`

## 语法知识

1. tabular: format text into columns and rows.

2. itemize: gives us a bullet-list. The \begin{itemize} ... \end{itemize} pair signifies we want a bullet-list of the enclosed material. Each item of the list is specified by an \item command.

3. textbf & textit
    - The \textit command produces roman family, medium series, italic shape type.
    - The \textbf command produces roman family, boldface series, upright shape type.
