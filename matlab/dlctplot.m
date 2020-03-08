% DLCTPLOT Plots DLCT directional albedo.
%
%   DLCTSPLOT(DIR) Plots the NLOS directional albedo DIR.
%
%   Author:  Sean I. Young  (Stanford University)
%   Contact: sean0@stanford.edu, seannz@gmail.com
%
% Copyright 2019-2020 Stanford University, Stanford CA 94305, USA
%
%                         All Rights Reserved
%
% Permission to use, copy, modify, and distribute this software and
% its documentation for any purpose other than its incorporation into
% a commercial product is hereby granted without fee, provided that
% the above copyright notice appear in all copies and that both that
% copyright notice and this permission notice appear in supporting
% documentation, and that the name of Stanford University not be used
% in advertising or publicity pertaining to distribution of the
% software without specific, written prior permission.
%
% STANFORD UNIVERSITY DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
% SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
% FITNESS FOR ANY PARTICULAR PURPOSE. IN NO EVENT SHALL STANFORD
% UNIVERSITY BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL
% DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
% OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
% TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
% PERFORMANCE OF THIS SOFTWARE.

function dlctplot(dir)
dir_label = {'x','y','z'};
dims = size(dir);
for i = 1:3
    subplot(1,3,i);
    imagesc(dir(:,:,i));
    colormap(gray);
    title(sprintf('$%s$-directional albedo',dir_label{i}));
    axis off;
    pbaspect([dims(1:2),1]);
end
