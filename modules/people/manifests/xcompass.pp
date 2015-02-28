class people::xcompass{
 # install mac apps
  package {
    'DiskWave':
      source => "http://diskwave.barthe.ph/download/DiskWave_0.4.dmg",
      provider => appdmg;
    'XMind':
      source => "http://www.xmind.net/xmind/downloads/xmind-macosx-3.4.1.201401221918.dmg",
      provider => appdmg;
    'Haroopad':
      source => "https://dl.dropbox.com/s/yvjb90ywib551ex/haroopad-v0.12.0.dmg",
      provider => appdmg;
    'GanttProject':
      source => "http://dl.ganttproject.biz/ganttproject-2.6.6/ganttproject-2.6.6-r1715.dmg",
      provider => appdmg;
#    'Paintbrush':
#      source => "http://downloads.sourceforge.net/paintbrush/Paintbrush-2.1.1.zip",
#      provider => compressed_app;
#   'Genymotion':
#     source => "https://ssl-files.genymotion.com/genymotion/genymotion-2.0.3/genymotion-2.0.3.dmg",
#     provider => appdmg;
    'AndroidFileTransfer':
      source => "https://dl.google.com/dl/androidjumper/mtp/current/androidfiletransfer.dmg",
      provider => appdmg;
    'SQLiteBrowser':
      source   => 'http://jaist.dl.sourceforge.net/project/sqlitebrowser/sqlitebrowser/2.0%20beta1/sqlitebrowser_200_b1_osx.zip',
      provider => compressed_app;
    'FileZilla':
      source   => 'http://downloads.sourceforge.net/project/filezilla/FileZilla_Client/3.9.0.2/FileZilla_3.9.0.2_macosx-x86.app.tar.bz2?r=&ts=1406843417&use_mirror=iweb',
      flavor => 'tar.bz2',
      provider => compressed_app;
    'ffmpeg':
      ensure => present,
  }

#  include go
#  go::version { '1.4': }
  include projects::all
}
