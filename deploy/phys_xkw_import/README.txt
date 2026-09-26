知脉 · 高中物理知识点导入包
============================

内容：
  spas_phys_xkw_knowledge.sql   知识点树 SQL（约 1273 节点，幂等）
  import_phys_xkw_knowledge.sh  一键导入脚本
  README.txt                    本说明

服务器操作：
  1) 上传本 zip 到服务器，例如 /tmp/
  2) 解压：
       cd /www/wwwroot/xq.xmls.vip
       unzip -o /tmp/phys_xkw_import.zip -d /tmp/phys_xkw_import
  3) 执行（推荐在站点目录下，以便读取 config/env.sh）：
       cd /www/wwwroot/xq.xmls.vip
       chmod +x /tmp/phys_xkw_import/import_phys_xkw_knowledge.sh
       sed -i 's/\r$//' /tmp/phys_xkw_import/import_phys_xkw_knowledge.sh
       bash /tmp/phys_xkw_import/import_phys_xkw_knowledge.sh /tmp/phys_xkw_import/spas_phys_xkw_knowledge.sql

  或把文件拷进站点后再跑：
       mkdir -p sql scripts
       cp /tmp/phys_xkw_import/spas_phys_xkw_knowledge.sql sql/
       cp /tmp/phys_xkw_import/import_phys_xkw_knowledge.sh scripts/
       chmod +x scripts/import_phys_xkw_knowledge.sh
       bash scripts/import_phys_xkw_knowledge.sh

导入成功后，后台「知识点管理」选择学科「物理」即可看到树。
