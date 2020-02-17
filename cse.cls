%% cse.cls
%% Copyright 2020 Kevin Lin
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `author-maintained'.
%
% This work consists of the files exam.cls and exam.tex

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cse}[2020/02/17 CSE Exam Class]
\LoadClass[addpoints]{exam} % Requires the exam class v2.607beta or later

\usepackage[noend]{algpseudocode}
\usepackage{adjustbox}
\usepackage{amsfonts, amsmath, amsthm, amssymb}
\usepackage{calc}
\usepackage[outline, pdftex]{contour}
\usepackage[shortlabels, inline]{enumitem}
\usepackage{environ}
\usepackage{import}
\usepackage{hyperref}
\usepackage{listings}
\usepackage{multicol, multirow}
\usepackage{setspace}
\usepackage{tabularx}
\usepackage{tikz}
\usepackage{titlesec}
\usepackage{wasysym}
% Primary TikZ libraries
\usetikzlibrary{
    decorations,
    arrows,
    shapes,
    positioning,
    calc,
    chains,
    graphs,
    graphs.standard,
    quotes,
}
% Fonts
\usepackage[tt=false]{libertine}
\usepackage[varqu]{inconsolata}
\usepackage{microtype}
% LuaLaTeX extensions
\usepackage{iftex}
\ifluatex
    \usetikzlibrary{graphdrawing}
    \usegdlibrary{trees, layered, force, circular}
    \usepackage{fontspec}
    \setmonofont{Inconsolata}
    \usepackage{unicode-math}
    \setmathfont[Scale=MatchUppercase]{libertinusmath-regular.otf}
\else
    \usepackage[utf8]{inputenc}
    \usepackage[T2A,T1]{fontenc}
    \usepackage[libertine]{newtxmath}
\fi

% Identification format
\def\identification{Name: \fillin[\name][1.5in]}
% Page format
\extrawidth{-0.5in}
% Header and footer format
\pagestyle{headandfoot}
\lhead{\oddeven{\textbf{\coursenumber\ \@title\solinline{\ Solution}}}{\offering}}
\chead{}
\rhead{\oddeven{\identification}{}}
\firstpageheader{\textbf{\coursenumber\ \@title\solinline{\ Solution}}}{}{}
\lfoot{\oddeven{}{\thepage}}
\cfoot{}
\rfoot{\oddeven{\thepage}}{}
% Define title
\def\maketitle{
    \mbox{\huge\libertineDisplay\coursetitle}
    \vskip 1ex
    \mbox{\large\libertineDisplay\offering}
    \vskip 4ex
}

% Paragraph format
\parindent=0pt
\onehalfspacing

% Use sans-serif for all bold fonts
\makeatletter
\DeclareRobustCommand\bfseries{%
  \not@math@alphabet\bfseries\mathbfsf
  \fontfamily\sfdefault\fontseries\bfdefault\selectfont
}
\makeatother

% tabularx format
\renewcommand\tabularxcolumn[1]{m{#1}}

% Listings format
\lstset{
    aboveskip=0pt,
    basicstyle=\ttfamily,
    belowskip=0pt,
    breaklines=true,
    columns=fullflexible,
    keepspaces=true,
    showstringspaces=false,
}

% Define question format
\pointpoints{pt}{pts}
\newcommand{\questiontitle}[1]{\textbf{#1}\enskip}
\renewcommand{\questionshook}{\setlength{\leftmargin}{0pt}}

% Multiple choice questions
% Gradescope template for multiple choice questions
\newcommand{\mcqb}{\textbf{\Large$\Circle$}}
\newcommand{\mcqs}{\textbf{\textcolor{blue}{\Large$\CIRCLE$}}}
\newcommand{\mcqsol}{\ifprintanswers\mcqs{}\else\mcqb{}\fi}
% Gradescope template for multiple option questions
\newcommand{\moqb}{\raisebox{-1.6pt}{\Large$\square$}}
\newcommand{\moqs}{\raisebox{-1.6pt}{\textcolor{blue}{\Large$\blacksquare$}}}
\newcommand{\moqsol}{\ifprintanswers\moqs{}\else\moqb{}\fi}
% (Re)define choice and option environments
\RenewEnviron{choices}{
    \checkboxchar{\mcqb{}}
    \checkedchar{\mcqs{}}
    \begin{checkboxes}
        \BODY
    \end{checkboxes}
}
\NewEnviron{choices*}{
    \checkboxchar{\mcqb{}}
    \checkedchar{\mcqs{}}
    \begin{oneparcheckboxes}
        \BODY
    \end{oneparcheckboxes}
}
\NewEnviron{options}{
    \checkboxchar{\moqb{}}
    \checkedchar{\moqs{}}
    \begin{checkboxes}
        \BODY
    \end{checkboxes}
}
\NewEnviron{options*}{
    \checkboxchar{\moqb{}}
    \checkedchar{\moqs{}}
    \begin{oneparcheckboxes}
        \BODY
    \end{oneparcheckboxes}
}
% Provide column-restricted environments
\setlength\multicolsep{5pt}
\SetEnumitemKey{cols}{
  before=\raggedcolumns\begin{multicols}{#1},
  after=\end{multicols}\vspace*{-\baselineskip}}

% Define solution style
\unframedsolutions
\renewcommand{\solutiontitle}{}
\SolutionEmphasis{\color{blue}}
\CorrectChoiceEmphasis{\color{blue}}
\newcommand{\solinline}[2][]{\ifprintanswers\textcolor{blue}{#2}\else#1\fi}
% Contours to skip underline ink when it intersects with a descender
\newlength{\clength}
\setlength{\clength}{1pt}
\contourlength{\clength}
\setlength\answerclearance{\clength + 1.3pt}
% Add contour to exam.cls answerline
\makeatletter
\renewcommand\answerline[1][{}]{%
  % One optional argument, the default value of which is empty.
  \ifx\@queslevel\ques@ref
    \let\ans@l=\questionlabel
  \else
    \ifx\@queslevel\part@ref
      \let\ans@l=\partlabel
    \else
      \ifx\@queslevel\subpart@ref
        \let\ans@l=\subpartlabel
      \else
        \ifx\@queslevel\subsubpart@ref
          \let\ans@l=\subsubpartlabel
        \else
          % Oops; no question level defined.
          % We must be outside of the questions environment.
          % Just leave out the label, I guess:
          \def\ans@l{}%
        \fi
      \fi
    \fi
  \fi
  \par \nobreak \vskip \answerskip
  \hfill
  \ifprintanswers
    \ans@l~\hbox to 0pt{\hbox to \answerlinelength{\hrulefill}\hss}%
    \raise \answerclearance\hbox to \answerlinelength{%
      % 2016/05/10: Added \color@begingroup and \color@endgroup:
      \color@begingroup
      \CorrectChoice@Emphasis \hfil \contour{white}{#1}\hss
      \color@endgroup}%
  \else
    \ans@l~\hbox to \answerlinelength{\hrulefill}%
  \fi
  \par
}% answerline
% Add contour to exam.cls fillin, remove hfil, rubber length default
\def\@fillin@relay[#1]{%
  % The first argument is in \fillin@ans, the second is #1.
  \leavevmode
  \ifprintanswers
    \rlap{\raise -\answerclearance \hbox to #1{\hrulefill}}%
    \hbox to #1{\color@begingroup\CorrectChoice@Emphasis
                \contour{white}{\fillin@ans} \color@endgroup}%
  \else
    \raise -\answerclearance \hbox to #1{\hrulefill}%
  \fi
}% @fillin@relay
\makeatother
