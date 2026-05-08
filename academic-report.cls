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
\RequirePackage{csquotes}                   % Context-sensitive quotes
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
        \gdef\studentcommalist{#1 (#2)}%
    \else
        \xdef\studentcommalist{\studentcommalist, #1 (#2)}%
    \fi
}

% --- Formatting ---

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

% --- Front Matter Templates ---

\newcommand{\titlerow}[1]{\expandafter\@titlerow#1\@nil}
\def\@titlerow#1 | #2 | #3\@nil{%
    {\large #1 (#2)}\par \vspace{0.2cm}
    \ifx\relax#3\relax\else\@titlerow#3\@nil\fi
}

% 1. Title Page
\newcommand{\maketitlepage}{
    \begin{titlepage}
        \centering
        {\Huge \textbf{\@projecttitle}}\\[1.0cm]
        \ifdef{\@universitylogo}{
            \includegraphics[width=0.18\linewidth]{\@universitylogo}\\[0.9cm]
        }{
            \vspace{2cm}
        }
        {\Large \textbf{\@projecttype}}\\[0.2cm]
        {\large \textit{Submitted by}}\\[0.2cm]
        \ifdef{\@groupnumber}{{\large Group Number: \@groupnumber}\par \vspace{0.1cm}}{}
        
        \expandafter\titlerow\expandafter{\studentlist}\par \vspace{0.5cm}

        {\itshape in partial fulfillment for the award of the degree of}\\[0.15cm]
        {\Large \textbf{\@degree}}\\[0.2cm]
        {\large in}\\[0.2cm]
        {\Large \textbf{\@branch}}\\[0.2cm]
        {\large Under the Guidance of}\\
        {\large \textbf{\@guidename}}\\
        {\large \@guidedesignation \\ \@department \\ \@institution}
        \vfill
        \ifdef{\@institutelogo}{
            \includegraphics[width=0.18\linewidth]{\@institutelogo}\\[0.5cm]
        }{}
        {\Large \textbf{\@institution}}\\
        {\large (\@university)}\\
        {\large \@location}\\
        {\large Academic Year - \@academicyear}
    \end{titlepage}
}

% 2. Certificate
\newcommand{\makecertificate}[2]{
    \chapter*{Certificate}
    \thispagestyle{empty}
    \vspace{1cm}
    \begin{center}
        \includegraphics[width=0.15\linewidth]{\@institutelogo}
    \end{center}
    \vspace{0.5cm}
    This is to certify that the project report entitled \textbf{\enquote{\@projecttitle}} is a bonafide work carried out by \textbf{\studentcommalist} in partial fulfillment of the requirements for the award of the degree of \textbf{\@degree} in \textbf{\@branch}, under my supervision during the academic year \@academicyear.
    
    \vspace{2cm}
    \noindent
    \begin{tabular}{@{}p{0.33\textwidth} p{0.33\textwidth} p{0.33\textwidth}@{}}
        Guide Signature & HoD Signature & Principal Signature \\[0.5cm]
        (\@guidename) & (#1) & (#2)
    \end{tabular}

    \vspace{2cm}
    \noindent
    Name and signature of Examiners along with date \\[1cm]
    \vspace{1cm}
    \noindent
    Examiner 1:  \\[1cm]
    Examiner 2: 
    \clearpage 


}

\newcommand{\splitstudent}[1]{\expandafter\@splitstudent#1\@nil}
\def\@splitstudent#1 | #2 | #3\@nil{%
    \global\advance\rowcount by 1
    \the\rowcount & #1 & #2 & \\[1ex] \hline
    \ifx\relax#3\relax\else\@splitstudent#3\@nil\fi
}

% 3. Declaration
\newcommand{\makedeclaration}{
    \chapter*{DECLARATION}
    \thispagestyle{empty}
    We, hereby declare that the \@projecttype\ work entitled \enquote{\@projecttitle} is a bonafide work and has been carried out by us under the guidance of \@guidename, \@guidedesignation, \@department, \@institution, in partial fulfillment of the requirements of the degree of \@degree\ in \@branch\ of \@university. 
    
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
    \expandafter\splitstudent\expandafter{\studentlist}
    \end{tabular}
    \end{center}
    \begin{flushleft}
    Place: \@location \\
    Date: \\
    \end{flushleft}
    Certified that these candidates are students of \@department\ of \@institution. They have carried out the project work of titled \enquote{\@projecttitle} as \@projecttype\ work. It is in partial fulfillment for completing the requirement for the award of \@degree\ degree by \@university. The works is original and duly certify the same.  
    \vspace{1cm}
    \begin{flushleft}
    Guide Name: \@guidename \\
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
}
