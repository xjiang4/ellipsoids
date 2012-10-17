classdef EmailLoggerBuilder
    methods (Access=private)
        function self=EmailLoggerBuilder()
        end
    end
    methods (Static)
        function emailLogger=fromConfRepoMgr(confRepoMgr,appName,...
                inpSubjSuffName,mainLogFileName,fTempDirGetter,varargin)
            %
            import modgen.common.throwerror;
            [~,~,addAttachNameList]=modgen.common.parseparext(varargin,...
                {'emailAttachmentNameList';...
                {};...
                'iscellofstring(x)'},0);
            tmpDirName=fTempDirGetter(appName);
            dstConfFileName=[tmpDirName,filesep,'cur_conf','.xml'];
            confRepoMgr.copyConfFile(dstConfFileName,'destIsFile',true);
            %
            svnURL=modgen.subversion.svngeturl(pwd);
            [~,pidVal,~]=modgen.system.getpidhost();
            subjectSuffix=[',pid:',num2str(pidVal),',conf:',...
                confRepoMgr.getCurConfName(),inpSubjSuffName,...
                ',svnURL:',svnURL]; 
            addArgList={};
            if confRepoMgr.isParam('emailNotification.smtpUserName')
                addArgList=[addArgList,{'smtpUserName',...
                    confRepoMgr.getParam('emailNotification.smtpUserName')}];
                if confRepoMgr.isParam('emailNotification.smtpPassword')
                    addArgList=[addArgList,{'smtpPassword',...
                        confRepoMgr.getParam('emailNotification.smtpPassword')}];
                end
            elseif confRepoMgr.isParam('emailNotification.smtpPassword')
                throwerror('wrongInput',['smtpPassword can only be ',...
                    'specified when smtpUser name is specified']);
            end
            revisionStr=modgen.subversion.getrevision('ignoreErrors',true);
            emailLogger=modgen.logging.EmailLogger(...
                'emailDistributionList',...
                confRepoMgr.getParam('emailNotification.distributionList'),...
                'emailAttachmentNameList',...
                [{mainLogFileName,dstConfFileName},addAttachNameList],...
                'smtpServer',confRepoMgr.getParam('emailNotification.smtpServer'),...
                'subjectSuffix',subjectSuffix,...
                'loggerName',...
                [appName,':',revisionStr],addArgList{:},...
                'dryRun',~confRepoMgr.getParam('emailNotification.isEnabled'));
        end
    end
end

