# LICENSE: GPL v3
require 'fileutils'

system("wget -N -np -r -k -p ftp://topex.ucsd.edu/pub/srtm30_plus/srtm30")
system("wget -N -np -r -k -p ftp://topex.ucsd.edu/pub/srtm30_plus/topo1_topo2")

GRD_EXT = '.grd'

Dir.chdir('./topex.ucsd.edu/pub/srtm30_plus/srtm30'){
  Dir.chdir('data'){
    SUFFIX = '.srtm.swap'
    Dir.glob('*.srtm').each{|f| system("dd if=#{f} of=../grd/#{f.split('.')[0] + SUFFIX} conv=swab bs=240")}
  }

  Dir.chdir('grd'){
    {
      "e020n40" => %w(020  060 -10  40),
      "e020n90" => %w(020  060  40  90),
      "e020s10" => %w(020  060 -60 -10),
      "e060n40" => %w(060  100 -10  40),
      "e060n90" => %w(060  100  40  90),
      "e060s10" => %w(060  100 -60 -10),
      "e100n40" => %w(100  140 -10  40),
      "e100n90" => %w(100  140  40  90),
      "e100s10" => %w(100  140 -60 -10),
      "e140n40" => %w(140  180 -10  40),
      "e140n90" => %w(140  180  40  90),
      "e140s10" => %w(140  180 -60 -10),
      "w020n40" => %w(-020  020 -10  40),
      "w020n90" => %w(-020  020  40  90),
      "w020s10" => %w(-020  020 -60 -10),
      "w060n40" => %w(-060 -020 -10  40),
      "w060n90" => %w(-060 -020  40  90),
      "w060s10" => %w(-060 -020 -60 -10),
      "w100n40" => %w(-100 -060 -10  40),
      "w100n90" => %w(-100 -060  40  90),
      "w100s10" => %w(-100 -060 -60 -10),
      "w140n40" => %w(-140 -100 -10  40),
      "w140n90" => %w(-140 -100  40  90),
      "w140s10" => %w(-140 -100 -60 -10),
      "w180n40" => %w(-180 -140 -10  40),
      "w180n90" => %w(-180 -140  40  90),
      "w180s10" => %w(-180 -140 -60 -10),
      "w180s60" => %w(-180 -120 -90 -60),
      "w120s60" => %w(-120 -060 -90 -60),
      "w060s60" => %w(-060  000 -90 -60),
      "w000s60" => %w(000  060 -90 -60),
      "e060s60" => %w(060  120 -90 -60),
      "e120s60" => %w(120  180 -90 -60)
    }.each{|f, wesn|
      swapFile = f + SUFFIX
      grdFile = './' + f + GRD_EXT
      system("GMT xyz2grd #{swapFile} -G#{grdFile}=ns -I30c -R#{wesn.join('/')} -ZTLh -F -V")
      FileUtils.ln_s(grdFile , 'srtm30_' + wesn.join('_') + GRD_EXT)
      system(p "rm -f #{swapFile}")
    }
  }
}
