\ProvidesClass{tumDiss}
\NeedsTeXFormat{LaTeX2e}

% --- Class options
% title page font style
\newif\if@titlepage@sansserif
\DeclareOption{seriftitlepage}{\@titlepage@sansseriffalse}%
\DeclareOption{sansseriftitlepage}{\@titlepage@sansseriftrue}%
% title page layout lines
\newif\if@titlepage@showlayout
\DeclareOption{layouttitlepage}{\@titlepage@showlayouttrue}%
\DeclareOption{nolayouttitlepage}{\@titlepage@showlayoutfalse}%
% add toc to toc
\newif\if@addtoctotoc
\DeclareOption{addtoctotoc}{\@addtoctotoctrue}%
\DeclareOption{notocintoc}{\@addtoctotocfalse}%
% pass remaining options to scrbook class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrbook}}%
% default options
\ExecuteOptions{seriftitlepage,nolayouttitlepage,addtoctotoc}%
\ProcessOptions\relax

% --- Derive from class scrbook
\LoadClass[%
  a4paper,
  twoside       = false,
  fontsize      = 12pt,
  chapterprefix = false,           % don't print "Chapter XX" before chapter headings
  toc           = listof,          % include list of tables and figures in toc
  toc           = bib,             % include bib in toc
  numbers       = noenddot         % If you include an Appendix, each number will get
                                   % an ugly dot at the end, e.g. "Figure 3.9.: XXX".
                                   % This option prevents this and makes it
                                   % "Figure 3.9: XXX" as it should be
]{scrbook}%

% --- Load packages
% use manual text positioning on title page
\if@titlepage@showlayout
  \RequirePackage[showboxes,absolute]{textpos}%
\else
  \RequirePackage[absolute]{textpos}%
\fi

% used for toc tweaking
\RequirePackage{etoolbox}%

% add toc to toc
\if@addtoctotoc
  \RequirePackage{tocbibind}%
\fi

% load tumcolor package (xcolor, pgfplots and a tum-plotcycle list)
\RequirePackage[pgfplots,svgnames,x11names]{tumcolor}%

% --- Document styles
% caption style
\addtokomafont{captionlabel}{\bfseries}%
\addtokomafont{caption}{\small}%

% --- Document properties
% parameters as set by the main file.
\newcommand{\faculty}[1]{\def\@faculty{#1}}%
\newcommand{\degree}[1]{\def\@degree{#1}}%
\newcommand{\vorsitz}[1]{\def\@vorsitz{#1}}%
\newcommand{\erstpruef}[1]{\def\@erstpruef{#1}}%

\newif\ifzweitpruefaffil
\newcommand{\zweitpruef}[2][]{%
  \def\@zweitpruef{#2}
  \ifx#1\empty\else
    \def\@zweitpruefaffil{#1}
    \zweitpruefaffiltrue
  \fi
}

\newif\ifdrittpruefset
\newif\ifdrittpruefaffil
\newcommand{\drittpruef}[2][]{%
  \ifx#2\empty\else
    \drittpruefsettrue
    \def\@drittpruef{#2}
    \ifx#1\empty\else
      \def\@drittpruefaffil{#1}
      \drittpruefaffiltrue
    \fi
  \fi
}

\newif\ifdateaccepted
\newcommand{\dateaccepted}[1]{%
  \ifx#1\empty\else
    \def\@dateaccepted{#1}
    \dateacceptedtrue
  \fi
}

% --- Titlepage
% The title page is fully centered.
\def\titlepagebindingcor#1{\def\@titlepagebindingcor{#1}}
\def\@titlepagebindingcor{0mm}
\RequirePackage{calc}%

\def\TUMLogoWidth{19mm}

% Left and right margins are exactly the same.
\def\defaultwidth{150mm}%
\def\defaulthpos{30mm + \@titlepagebindingcor}%

% Vertical positions of title page entities
\def\titlevpos{130mm}%
\def\informationvpos{160mm}%
\def\examinervpos{196.5mm}%
\def\datevpos{241mm}%

% --- Robustify
% clear textpos box
% textpos interacts badly with some packages due to a conflict with \shipout
% https://tex.stackexchange.com/questions/66804/unexpected-output-using-tikz-textpos
\def\cleartextposbox{\global\setbox\TP@holdbox\vbox{}}

\AtBeginDocument{%
% pdf links: only if hyperref was loaded in main file
\@ifpackageloaded{hyperref}{%
  \hypersetup{%
    bookmarks    = true,         % show bookmarks bar?
    pdftoolbar   = true,         % show Acrobat’s toolbar?
    pdfmenubar   = true,         % show Acrobat’s menu?
    pdffitwindow = false,        % window fit to page when opened
    pdfstartview = {FitH},       % fits the width of the page to the window
    pdftitle     = {\@title},    % title
    pdfauthor    = {\@author},   % author
    pdfsubject   = {PhD Thesis}, % subject of the document
    pdfcreator   = {\@author},   % creator of the document
    pdfnewwindow = true,         % links in new window
  }}{}%
}

% Title Page
\renewcommand\maketitle{%
\begin{titlepage}
    \if@titlepage@sansserif
      \sffamily
    \fi



    % Layouting helper
    \if@titlepage@showlayout
      % Logo box with 105% size rel. to TUM logo
      \begin{textblock*}{10.5mm}(9.75mm, 9.75mm)
          \hspace{1mm} \vspace{10.5mm}
      \end{textblock*}

      % top and bottom margin check for logo and fak text
      \begin{textblock*}{180mm}(25mm, 10mm)
          \hspace{1mm} \vspace{10mm}
      \end{textblock*}

      \begin{textblock*}{190mm}(10mm, 148.5mm) % mid
          \noindent\makebox[\hsize]{\rule{\textwidth}{1pt}}
      \end{textblock*}

      \begin{textblock*}{190mm}(10mm, 99mm) % first third
          \noindent\makebox[\hsize]{\rule{\textwidth}{1pt}}
      \end{textblock*}

      \begin{textblock*}{190mm}(10mm, 198mm) % second third
          \noindent\makebox[\hsize]{\rule{\textwidth}{1pt}}
      \end{textblock*}
    \fi



    % Logos
    % FAK logo
    \input{inc/fak_placement.tex}

    % FAK text
    %                         See TUM CD Handbook page 16
    %                         x    + x    + 0.5x
    \begin{textblock*}{120mm}(10mm + 10mm + 5mm + \@titlepagebindingcor, 13.78mm)
        \footnotesize
        \fontfamily{phv}\selectfont
        \noindent \textcolor{TUMBlue}{
          {\@faculty}
        }\\
        \fontfamily{phv}\selectfont
        \textcolor{TUMBlue}{
          %Technische Universit\"at M\"unchen
        }
    \end{textblock*}

    % MPI logo
    \begin{textblock*}{\TUMLogoWidth}(\paperwidth - \TUMLogoWidth - 56mm, 10mm)
        \noindent \includegraphics[height = 15mm]{MPI.pdf}
    \end{textblock*}



    % Titel und Autor
    % Keep the name position fixed. Longer titles expand towards top.
    \begin{textblock*}{\defaultwidth}[0,1](\defaulthpos, \titlevpos)
        \centering

        {\bfseries \LARGE \textcolor{TUMBlueDarkest} \@title}
        \ifdefempty{\@subtitle}{}{\vspace{1ex}\bfseries\large \@subtitle}

        \vspace{15mm}

        vorgelegt von\\
        
        \vspace{5mm}

        {\bfseries \Large \@author}\\

    \end{textblock*}



    % Informationstext
    \begin{textblock*}{\defaultwidth}(\defaulthpos, \informationvpos)
        \centering
        % \raggedright

        Zur Erlangung des akademischen Grades eines\\

        \vspace{6mm}

        \centering {\bfseries \large {\@degree}}\\

        \vspace{6mm}
        % \raggedright

        der Fakult\"at f\"ur Chemie und Chemische Biologie\\
        der Technischen Universit\"at Dortmund\\

        \vspace{6mm}
        % \raggedright
        
        Angefertigt am Max-Planck Institut f\"ur Molekulare Physiologie in Dortmund\\

        \vspace{30mm}

        \centering {\bfseries \large {June 2024}}\\

    \end{textblock*}



    % Prüfer
    % \begin{textblock*}{\defaultwidth}(\defaulthpos, \examinervpos)
    %     \centering
    %     \raggedright

    %     \textbf{Vorsitzender:}\\
    %     \hspace{8mm}\hphantom{1. }\@vorsitz

    %     \vspace{2mm}

    %     \textbf{Pr\"ufende der Dissertation:}\\
    %     \hspace{8mm}1. \@erstpruef\\
    %     \hspace{8mm}2. \@zweitpruef
    %     \ifzweitpruefaffil
    %       ,\\\hspace{8mm}\hphantom{2. }\@zweitpruefaffil
    %     \fi
    %     \ifdrittpruefset
    %       \\\hspace{8mm}3. \@drittpruef
    %       \ifdrittpruefaffil
    %         ,\\\hspace{8mm}\hphantom{2. }\@drittpruefaffil
    %       \fi
    %     \fi

    % \end{textblock*}



    % % Daten
    % \begin{textblock*}{\defaultwidth}(\defaulthpos, \datevpos)
    %     \raggedright

    %     Die Dissertation wurde am {\@date} bei der Technischen Universit\"at
    %     M\"unchen eingereicht und durch die {\@faculty}
    %     \ifdateaccepted
    %       am {\@dateaccepted }
    %     \fi
    %     angenommen.

    % \end{textblock*}

\end{titlepage}

% force empty page
\mbox{}
\newpage
\thispagestyle{empty}
\null\newpage\cleartextposbox

} % end \renewcommand\maketitle

% --- toc tweaking
% make subsubsection numbered
\setcounter{secnumdepth}{3}

% make subsubsection appear in TOC
\setcounter{tocdepth}{3}
\endinput
%% End of file `tumDiss.cls'.
