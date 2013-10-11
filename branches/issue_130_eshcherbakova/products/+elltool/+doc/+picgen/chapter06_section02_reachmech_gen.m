function chapter06_section02_reachmech_gen
%     REACHMECH_GEN - creates picture "chapter05_section03_reachmech.eps" in
%     doc/pic   
% $Author: <Elena Shcherbakova>  <shcherbakova415@gmail.com> $    $Date: <9 October 2013> $
% $Copyright: Moscow State University,
%            Faculty of Computational Mathematics and Cybernetics,
%            System Analysis Department 2013 $
    close all
    elltool.doc.snip.s_chapter06_section02_snippet01;
    elltool.doc.snip.s_chapter06_section02_snippet02;
    figHandle = findobj('Type','figure');
    %elltool.doc.picgen.PicGenController.savePicFileNameByCaller(figHandle(4), 0.5, 0.6);

end