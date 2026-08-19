%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Vignesh Iyer                                 %
% MS CSE ASU                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2023/01/11 v0.2 Resume class]

\LoadClass[11pt,letterpaper]{article} % Font size and paper type

\usepackage[left=0.3in,top=0.3in,right=0.3in,bottom=0.3in]{geometry} % set document margins
\usepackage[parfill]{parskip} % Remove paragraph indentation

\usepackage{etoolbox}
\usepackage{keycommand}
\usepackage{xstring}
\usepackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=blue,
    urlcolor=blue,
}
\usepackage{fontawesome5}


% Load the fontspec package to set the font
\usepackage[scaled]{helvet} % Load the Helvetica font
\renewcommand\familydefault{\sfdefault} % Set the  font family to sans-serif
\usepackage[T1]{fontenc} % Use the T1 font encoding to ensure proper character rendering

\pagestyle{empty}

% -------------- README --------------
% Visit https://github.com/vgnshiyer/ASU-sparkysundevil-resume-template for comprehensive documenation.

% ------------ Utilities ------------

\def \separator {
    \textbf{\Large\textbullet}
}

\newcommand{\email}[1]{\href{mailto:#1}{#1}}%
\newcommand{\profilelink}[1]{\href{https://#1}{#1}}%

\newcommand{\isA}[1]{
    \expandafter\ifstrequal\expandafter{#1}{default}{}{a}
}

\newcommand\sectionTitle[1]{%
    \begingroup
        \textbf{\MakeUppercase{#1}}
        \vspace{0.4em}
        \hrule
        \vspace{-0.3em}
    \endgroup
}%

% ------------------------------------

% ------------- Header --------------
\newcommand\printNameTitle[1]{%
    \begingroup
        \hfill{\MakeUppercase{\Huge\bfseries #1}}\hfill
        \break
        \vspace{-0.5em}
        \hrule
    \endgroup
}%

\newkeycommand{\introduction}[
    fullname,
    email,
    phone,
    linkedin,
    github
]{%
    \begin{center}
        {\Huge \scshape \commandkey{fullname}} \\[4pt]

        \small
        \ifcommandkey{phone}{%
            \raisebox{-0.1\height}{\faPhone}\ \commandkey{phone}%
        }{}%
        \ifcommandkey{email}{%
            \hspace{8pt}
            \href{mailto:\commandkey{email}}{%
                \raisebox{-0.2\height}{\faEnvelope}\ \commandkey{email}%
            }%
        }{}%
        \ifcommandkey{linkedin}{%
            \hspace{8pt}
            \href{https://\commandkey{linkedin}}{%
                \raisebox{-0.2\height}{\faLinkedin}\ \commandkey{linkedin}%
            }%
        }{}%
        \ifcommandkey{github}{%
            \hspace{8pt}
            \href{https://\commandkey{github}}{%
                \raisebox{-0.2\height}{\faGithub}\ \commandkey{github}%
            }%
        }{}

        \vspace{4pt}
    \end{center}%
}%

%
%
% \newkeycommand{\introduction}[
%     fullname,
%     email,
%     phone,
%     linkedin,
%     github
% ]{%
%     \begin{center}%
%         \printNameTitle{\commandkey{fullname}}% Full name title
%         {%
%             \expandafter\ifstrequal\expandafter{phone}{}{}% Contact number
%             {%
%                 \ifcommandkey{phone}{\commandkey{phone}}{}%
%                 \expandafter\ifstrequal\expandafter{email}{}%
%                 {%
%                     \expandafter\ifstrequal\expandafter{linkedin}{}%
%                     {%
%                         \expandafter\ifstrequal\expandafter{github}{}%
%                         {%
%                             % empty %
%                         }{\separator}%
%                     }{\separator}%
%                 }{\separator}%
%             }% Contact number field ends here
%             \expandafter\ifstrequal\expandafter{email}{}{}% Email
%             {%
%                 \email{\commandkey{email}}%
%                 \expandafter\ifstrequal\expandafter{linkedin}{}%
%                 {%
%                     \expandafter\ifstrequal\expandafter{github}{}%
%                     {%
%                         % empty %
%                     }{\separator}%
%                 }{\separator}%
%             }% Email fields ends here
%             \expandafter\ifstrequal\expandafter{linkedin}{}{}% Linkedin
%             {%
%                 \href{https://\commandkey{linkedin}}{\commandkey{linkedin}}%
%                 \expandafter\ifstrequal\expandafter{github}{}
%                 {%
%                     % empty %
%                 }{\separator}%
%             }% Linkedin field ends here
%             \expandafter\ifstrequal\expandafter{github}{}{}% Github
%             {%
%                 \href{https://\commandkey{github}}{\commandkey{github}}%
%             }% Github field ends here
%         }
%     \end{center}%
% }%
%
% -----------------------------------

% ------------ Summary --------------
\newcommand{\summary}[1]{%
    \sectionTitle{Summary}%
    #1
}%

% -----------------------------------

% ------------ Education ------------
\newenvironment{educationSection}[1]{%
    \sectionTitle{#1}%
}%

\newkeycommand{\educationItem}[
    university,
    college,
    program,
    graduation,
    grade,
    coursework
]{%
    {% line 1
        \bf \commandkey{program}%
    } \hfill {%
        \commandkey{graduation}%
    } \\ % line end
    {% line 2
        \commandkey{university}%
    } \hfill \ifcommandkey{grade}{% Grade field is optional (Can be left empty)
        \commandkey{grade}%
    }{} \\ % line end
    {% line 3
        \commandkey{college}
    } \\[-1em] % line end
    {% line 4
        {\bf Coursework:} \commandkey{coursework}%
    }% line end
}%

% ------------------------------------

% -------------- Skills --------------
\newenvironment{skillsSection}[1]{%
    \sectionTitle{#1}%
}%

\newkeycommand{\skillItem}[
    category,
    skills
]{%
    {%
        \bf \commandkey{category}
    } {%
        \commandkey{skills}%
    }
}%

% ------------------------------------

% -------------- Experience -------------
\newenvironment{experienceSection}[1]{%
    \sectionTitle{#1}%
    \begin{list}{}{ % List for each highlight in the section
        \setlength{\leftmargin}{0em} % Margin within the section
    }%
        \item[]%
    }{%
    \end{list}%
}%

% -------------- achievement -------------
\newenvironment{achievementSection}[1]{%
    \sectionTitle{#1}%
    \begin{list}{}{ % List for each highlight in the section
        \setlength{\leftmargin}{0em} % Margin within the section
    }%
        \item[]%
    }{%
    \end{list}%
}%

\newkeycommand{\experienceItem}[
    company,
    position,
    location,
    duration
]{%
    \commandkey{company}
    % \hspace{0.1em}|\hspace{0.1em}
    % \commandkey{position}
    % \hspace{0.1em}|\hspace{0.1em}
    % \commandkey{location}
    \hfill {%
        \commandkey{duration}%
    }
    \vspace{-0.5em}%
}%

% ---------------------------------------

% ----------------- Project -------------
\newcommand{\renderProjectLink}[2]{%
    \IfStrEq{#1}{nil}{}{%
        \IfSubStr{#1}{,}{%
            % Custom label, URL
            \StrBefore{#1}{,}[\projectLinkLabel]%
            \StrBehind{#1}{,}[\projectLinkURL]%
        }{%
            % Only URL - use default label
            \def\projectLinkLabel{#2}%
            \def\projectLinkURL{#1}%
        }%
        \href{\projectLinkURL}{\projectLinkLabel}%
    }%
}

\newkeycommand{\projectItem}[
    title,
    live={},
    github={},
    keyHighlight={}
]{%
    \commandkey{title}%
    \hfill
    {%
        % Live
        \IfStrEq{\commandkey{live}}{nil}{}{%
            \ifcommandkey{live}{%
                \renderProjectLink{\commandkey{live}}{Live}%
            }{}%
        }%
        %
        % Separator
        \IfStrEq{\commandkey{live}}{nil}{}{%
            \IfStrEq{\commandkey{github}}{nil}{}{%
                \ifcommandkey{live}{%
                    \ifcommandkey{github}{%
                        \hspace{3pt}|\hspace{3pt}%
                    }{}%
                }{}%
            }%
        }%
        %
        % GitHub
        \IfStrEq{\commandkey{github}}{nil}{}{%
            \ifcommandkey{github}{%
                \renderProjectLink{\commandkey{github}}{Github}%
            }{}%
        }%
    }%
}
% ----------------------------------------
% ----------------- Project -------------
\newkeycommand{\activityItem}[title, duration, keyHighlight]{%
    
    \textbf{%
        \commandkey{title}%
    }
    - \commandkey{keyHighlight}%
    \hfill {%
        \commandkey{duration}
    }
}%


