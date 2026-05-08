\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{academic-report}[2024/05/08 Standardized Academic Report Class]

% Base class
\LoadClass[12pt,a4paper]{report}

% --- Standardized Packages ---
\RequirePackage{iftex}                     % Detect engine (pdflatex vs lualatex)

\ifpdftex
    \RequirePackage[T1]{fontenc}
    \RequirePackage[utf8]{inputenc}
    \RequirePackage{mathptmx}              % Standard Times New Roman for pdflatex
\else
    \RequirePackage{times}                 % Use system-agnostic 'times' package for LuaLaTeX
\fi

\RequirePackage{setspace}                 % Line spacing
\RequirePackage[a4paper, left=1.5in, right=1in, top=1in, bottom=1in, headheight=15pt]{geometry}
\RequirePackage{titlesec}                 % Chapter/section formatting
\RequirePackage{fancyhdr}                 % Header/Footer
\RequirePackage{graphicx}                 % Figures
\RequirePackage{hyperref}                 % Hyperlinks
\RequirePackage{tocloft}                  % TOC formatting
\RequirePackage{etoolbox}                 % Patching
\RequirePackage{xcolor}                   % Colors
\RequirePackage{enumitem}                 % Standardized lists
\RequirePackage[title,titletoc]{appendix} % Standardized appendices

% --- Bibliography ---
\RequirePackage[style=ieee,backend=bibtex]{biblatex}
\addbibresource{references.bib}

% --- Global Settings ---
\RequirePackage{tabularx}                   % Precise table widths
\RequirePackage{csquotes}                   % Context-sensitive quotes
\RequirePackage{mfirstuc}                 % Title case support
\RequirePackage{textcase}                 % Robust case conversion
\onehalfspacing
\hypersetup{
    colorlinks=true,
    linkcolor=black,
    filecolor=magenta,      
    urlcolor=cyan,
    citecolor=black,
}

% --- Metadata Variables ---
\newcommand{\projecttitle}[1]{\def\@projecttitle{#1}}
\newcommand{\projecttype}[1]{\def\@projecttype{#1}}
\newcommand{\institution}[1]{\def\@institution{#1}}
\newcommand{\department}[1]{\def\@department{#1}}
\newcommand{\university}[1]{\def\@university{#1}}
\newcommand{\location}[1]{\def\@location{#1}}
\newcommand{\academicyear}[1]{\def\@academicyear{#1}}
\newcommand{\guidename}[1]{\def\@guidename{#1}}
\newcommand{\guidedesignation}[1]{\def\@guidedesignation{#1}}
\newcommand{\degree}[1]{\def\@degree{#1}}
\newcommand{\branch}[1]{\def\@branch{#1}}
\newcommand{\groupnumber}[1]{\def\@groupnumber{#1}}
\newcommand{\universitylogo}[1]{\def\@universitylogo{#1}}
\newcommand{\institutelogo}[1]{\def\@institutelogo{#1}}
\newcommand{\hod}[1]{\def\@hod{#1}}
\newcommand{\principal}[1]{\def\@principal{#1}}
\newcommand{\institutionDesc}[1]{\def\@institutionDesc{#1}}

% Student handling
\newcounter{studentcount}
\newcommand{\studentlist}{}      % For Declaration Table
\newcommand{\studentcommalist}{} % For Certificate (Comma-separated)

\newcommand{\addstudent}[2]{%
    \stepcounter{studentcount}%
    % Append to list: "Name | USN | " for parsing
    \gappto\studentlist{#1 | #2 | }%
    % Append to comma format: "Name (USN)"
    \ifnum\value{studentcount}=1
        \gdef\studentcommalist{\capitalisewords{#1} (\MakeUppercase{#2})}%
    \else
        \xdef\studentcommalist{\studentcommalist, \capitalisewords{#1} (\MakeUppercase{#2})}%
    \fi
}

% --- Formatting ---
\titleformat{\chapter}[hang]{\bfseries\centering\LARGE}{Chapter \thechapter}{1em}{}
\titleformat{\section}[hang]{\bfseries\Large}{\thesection}{1em}{}

% --- Header/Footer Styles ---
\pagestyle{fancy}
\fancyhf{}
\lhead{\textit{\@runningtitle}}
\lfoot{\textit{\@footerleft}}
\rfoot{\textit{Page \thepage}}

\newcommand{\runningtitle}[1]{\def\@runningtitle{#1}}
\newcommand{\footerleft}[1]{\def\@footerleft{#1}}

% Patch chapter pages to use fancy style
\patchcmd{\chapter}{\thispagestyle{plain}}{\thispagestyle{fancy}}{}{}

% --- Helpers ---
\newcommand{\titlerow}[1]{\expandafter\@titlerow#1\@nil}
\def\@titlerow#1 | #2 | #3\@nil{%
    {\large \MakeUppercase{#1} (\MakeUppercase{#2})}\par \vspace{0.2cm}
    \ifx\relax#3\relax\else\@titlerow#3\@nil\fi
}

\newcommand{\splitstudentrow}[1]{\expandafter\@splitstudentrow#1\@nil}
\def\@splitstudentrow#1 | #2 | #3\@nil{%
    \global\advance\rowcount by 1
    \the\rowcount & \capitalisewords{#1} & \MakeUppercase{#2} & \\[1ex] \hline
    \ifx\relax#3\relax\else\expandafter\@splitstudentrow#3\@nil\fi
}

% --- Front Matter Templates ---

% 1. Title Page
\newcommand{\maketitlepage}{
    \newgeometry{left=1.5in, right=1in, top=0.75in, bottom=0.75in}
    \begin{titlepage}
        \centering
        \begin{onehalfspace}
            {\Huge \textbf{\@projecttitle}}\par
        \end{onehalfspace}
        \vfill
        \ifdef{\@universitylogo}{
            \includegraphics[width=0.18\linewidth]{\@universitylogo}\par\vfill
        }{
            \vfill
        }
        {\Large \textbf{\@projecttype}}\\[0.2cm]
        {\large \textit{Submitted by}}\\[0.2cm]
        \ifdef{\@groupnumber}{{\large Group Number: \@groupnumber}\par \vspace{0.1cm}}{}
        
        \expandafter\titlerow\expandafter{\studentlist}\par \vfill

        {\itshape in partial fulfillment for the award of the degree of}\\[0.15cm]
        {\Large \textbf{\MakeUppercase{\@degree}}}\\[0.2cm]
        {\large in}\\[0.2cm]
        {\Large \textbf{\MakeUppercase{\@branch}}}\\[0.2cm]
        \vfill
        {\large Under the Guidance of}\\
        {\large \textbf{\MakeUppercase{\@guidename}}}\\
        {\large \@guidedesignation \\ \@department \\ \@institution}
        \vfill
        \ifdef{\@institutelogo}{
            \includegraphics[width=0.18\linewidth]{\@institutelogo}\\[0.3cm]
        }{}
        {\Large \textbf{\MakeUppercase{\@institution}}}\\
        {\large (\@institutionDesc)}\\
        {\large \@location}\\
        {\large Academic Year - \@academicyear}
    \end{titlepage}
    \restoregeometry
}

% 2. Certificate
\newcommand{\makecertificate}{
    \chapter*{Certificate}
    \thispagestyle{empty}
    \begin{center}
        \includegraphics[width=0.15\linewidth]{\@institutelogo}
    \end{center}
    \vspace{0.5cm}
    This is to certify that the project report entitled \textbf{\enquote{\@projecttitle}} is a bonafide work carried out by \textbf{\studentcommalist} in partial fulfillment of the requirements for the award of the degree of \textbf{\capitalisewords{\@degree}} in \textbf{\capitalisewords{\@branch}}, under my supervision during the academic year \@academicyear.
    
    \vspace{2cm}
    \noindent
    \begin{tabularx}{\textwidth}{@{}X >{\centering\arraybackslash}X >{\raggedleft\arraybackslash}X@{}}
        Guide Signature & HoD Signature & Principal Signature \tabularnewline[0.5cm]
        (\@guidename) & \@hod & \@principal
    \end{tabularx}

    \vspace{2cm}
    \noindent
    Name and signature of Examiners along with date \\[1cm]
    \vspace{1cm}
    \noindent
    Examiner 1:  \\[1cm]
    Examiner 2: 
    \clearpage 
}

% 3. Declaration
\newcommand{\makedeclaration}{
    \chapter*{DECLARATION}
    \thispagestyle{empty}
    We, hereby declare that the \capitalisewords{\@projecttype}\ work entitled \enquote{\@projecttitle} is a bonafide work and has been carried out by us under the guidance of \capitalisewords{\@guidename}, \capitalisewords{\@guidedesignation}, \capitalisewords{\@department}, \capitalisewords{\@institution}, in partial fulfillment of the requirements of the degree of \capitalisewords{\@degree}\ in \capitalisewords{\@branch}\ of \capitalisewords{\@university}. 
    
    I further declare that, to the best of my knowledge and belief, this project has not been submitted either in part or in full to any other university for the award of any degree. 
    
    \vspace{0.3cm}
    \begin{flushleft}
    Candidate details: 
    \end{flushleft}
    \vspace{0.1cm}
    \begin{center}
    \begin{tabular}{|c|l|c|c|}
    \hline
    \textbf{SL. NO.} & \textbf{Student Name} & \textbf{USN} & \textbf{Student’s Signature} \\
    \hline
    \global\newcount\rowcount
    \rowcount=0
    \expandafter\splitstudentrow\expandafter{\studentlist}
    \end{tabular}
    \end{center}
    \begin{flushleft}
    Place: \@location \\
    Date: \\
    \end{flushleft}
    Certified that these candidates are students of \capitalisewords{\@department}\ of \capitalisewords{\@institution}. They have carried out the project work of titled \enquote{\@projecttitle} as \capitalisewords{\@projecttype}. It is in partial fulfillment for completing the requirement for the award of \capitalisewords{\@degree}\ degree by \capitalisewords{\@university}. The work is original and I duly certify the same.  
    \vspace{1cm}
    \begin{flushleft}
    Guide Name: \capitalisewords{\@guidename} \\
    Date: \\
    Signature \\ 
    \end{flushleft}
    \clearpage
}

% 4. Standardized Appendices
\newcommand{\makeappendices}{
    \clearpage
    \appendix
    \renewcommand{\thechapter}{\Alph{chapter}}
    \renewcommand{\thesection}{\Roman{section}}
    \titleformat{\section}[hang]{\bfseries\Large}{\thesection}{1em}{}

    \section{Appendix A: Snapshots}
    \vfill \centering \textit{[Insert Snapshots Here]} \vfill
    \clearpage

    \section{Appendix B: Details of list of publications related to this project}
    \vspace{1cm}
    \noindent\large{Author Names: } \hrulefill \\
    \large{Paper Title: } \hrulefill \\
    \large{Name of the Conference or Journal:} \hrulefill \\
    \large{Place of the conference:} \hrulefill \\
    \large{Date of Conference:} \hrulefill
    \clearpage

    \section{Appendix C: Details of Patent}
    \vfill \centering \textit{[Insert Patent Details Here]} \vfill
    \clearpage

    \section{Appendix D: Details of Funding}
    \vfill \centering \textit{[Insert Funding Details Here]} \vfill
    \clearpage

    \section{Appendix E: POs and PSOs Mapped}
    \vfill \centering \textit{[Insert Mapping Tables Here]} \vfill
    \clearpage

    \section{Appendix F: Similarity report, AI Generated report}
    \vfill \centering \textit{[Insert Reports Here]} \vfill
    \clearpage
}
