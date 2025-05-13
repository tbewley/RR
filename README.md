# the Renaissance Repository (RR)
The codes in this consolidated repository are associated with three forthcoming texts,<BR>
<a href="http://robotics.ucsd.edu/SR.pdf">Structural Renaissance</a> (SR),
<a href="http://robotics.ucsd.edu/RR.pdf">Renaissance Robotics</a> (RR), and
<a href="http://robotics.ucsd.edu/NR.pdf">Numerical Renaissance</a> (NR),
in addition to various research papers, by Thomas Bewley.<BR>

SR, a <q cite="http://robotics.ucsd.edu/SR.pdf">modern first course in engineering analysis and design</q>,
is built around an introductory one-quarter presentation (typically in freshman/sophomore year) of statics,
and advocates two key notions:<BR>
<B>Divide and conquer</B>: that is, once a foundational subproblem (calculating trig functions, solving Ax=b completely, assembling the several equations of static equilibrium into Ax=b form, etc) is well understood,
those subproblems should be automated in computer code, so the engineer can then focus on the next larger problem,
ultimately leading to systems-level analysis, design optimization, and feedback control.<BR>
<B>Recognize and exploit linearity</B>: linear relationships are ubiquitous in engineering, but not always obvious;
identifying where certain relationships are linear, and the opportunities that this provides ()
SR is designed to be digested in a single quarter,  year in college.
The RR and NR texts follow up on these core foundational ideas.

RR, which covers dynamics, signals & systems, circuits, and classical control theory, among other things,
is intended to be accessible by advanced undergraduates; the first several chapters of it, which discuss how CPUs & microcontrollers (MCUs), electronics boards, and motors work, are likely also accessible by STEM-oriented high school makers.<BR><BR>

NR, which covers linear algebra, spectral methods, statistical representations, numerical simulation methods for ODEs & PDEs, derivative-based & derivative-free optimization, and state-space control & estimation theory, among other things, builds directly on the former, and is designed primarily for students in graduate school or beyond. Drafts of these two texts are maintained at the above two links; to expore further what they are about, please read their frontmatter.<BR><BR>

The various pedagogical codes in the Renaissance Repository (all prefixed by RR_, and mostly written in Matlab/Octave though there are also a few codes in Fortran and C)
are organized in this repo by the individual chapters of these two texts that review them.
If you are interested in studying these texts and using their associated codes,
please <B>clone</B> this reposistory (available at <a href="https://github.com/tbewley/RR.git">https://github.com/tbewley/RR.git</a>) to your computer(s) using, for example, <a href="https://desktop.github.com/">GitHub Desktop</a>, and fetch updates from its main branch
relatively often, as I currently update this repository multiple times a week.<BR><BR>
To set your Matlab/Octave path in a way that will streamline your use of these codes,
please call <a href="https://github.com/tbewley/RR/blob/main/RR_path_init.m">RR_path_init.m</a> from your <a href="https://www.mathworks.com/help/matlab/ref/startup.html">startup.m<a> file,
as outlined in sections A.4-A.5 of
<a href="http://robotics.ucsd.edu/RR.pdf">Renaissance Robotics</a>.<BR><BR>
To suggest a bug fix, please submit a <a href="https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests">pull request</a>.
  
All files in the the Renaissance Repository are Copyright 2024 by Thomas Bewley, and published under the <a href="https://github.com/tbewley/RR/blob/main/LICENSE">BSD 3-Clause License</a>.<BR>
