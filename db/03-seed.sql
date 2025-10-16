USE `hss_db`;

INSERT IGNORE INTO `visited_network` VALUES (2, 'ims.sipify');

INSERT INTO `imsu`
VALUES (3,'anhtong','','',1,1);

INSERT INTO `impu` 
VALUES (3,'sip:anhtong@ims.sipify',0,0,0,1,3,1,'','',0,1);

INSERT INTO `impi`
VALUES
(5,3,'anhtong@ims.sipify','anhtong',255,1,'\0\0',
 '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
 '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
 '000000000000','','',0,3600,1);

INSERT INTO `impi_impu` 
VALUES (5,5,3,0);

INSERT INTO `impu_visited_network` 
VALUES (3,3,2);

INSERT INTO `dsai_impu` 
VALUES (3,1,3,0);


INSERT INTO `imsu` VALUES (4,'hynguyen','','',1,1);
INSERT INTO `impu` VALUES (4,'sip:hynguyen@ims.sipify',0,0,0,1,4,1,'','',0,1);
INSERT INTO `impi` VALUES
(6,4,'hynguyen@ims.sipify','hynguyen',255,1,'\0\0',
 '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
 '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
 '000000000000','','',0,3600,1);
INSERT INTO `impi_impu` VALUES (6,6,4,0);
INSERT INTO `impu_visited_network` VALUES (4,4,2);
INSERT INTO `dsai_impu` VALUES (4,1,4,0);


INSERT INTO `imsu` VALUES (5,'duytran','','',1,1);
INSERT INTO `impu` VALUES (5,'sip:duytran@ims.sipify',0,0,0,1,5,1,'','',0,1);
INSERT INTO `impi` VALUES
(7,5,'duytran@ims.sipify','duytran',255,1,'\0\0',
 '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
 '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
 '000000000000','','',0,3600,1);
INSERT INTO `impi_impu` VALUES (7,7,5,0);
INSERT INTO `impu_visited_network` VALUES (5,5,2);
INSERT INTO `dsai_impu` VALUES (5,1,5,0);


INSERT INTO `imsu` VALUES (6,'quangnguyen','','',1,1);
INSERT INTO `impu` VALUES (6,'sip:quangnguyen@ims.sipify',0,0,0,1,6,1,'','',0,1);
INSERT INTO `impi` VALUES
(8,6,'quangnguyen@ims.sipify','quangnguyen',255,1,'\0\0',
 '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
 '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
 '000000000000','','',0,3600,1);
INSERT INTO `impi_impu` VALUES (8,8,6,0);
INSERT INTO `impu_visited_network` VALUES (6,6,2);
INSERT INTO `dsai_impu` VALUES (6,1,6,0);


INSERT INTO `imsu` VALUES (7,'duypham','','',1,1);
INSERT INTO `impu` VALUES (7,'sip:duypham@ims.sipify',0,0,0,1,7,1,'','',0,1);
INSERT INTO `impi` VALUES
(9,7,'duypham@ims.sipify','duypham',255,1,'\0\0',
 '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
 '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
 '000000000000','','',0,3600,1);
INSERT INTO `impi_impu` VALUES (9,9,7,0);
INSERT INTO `impu_visited_network` VALUES (7,7,2);
INSERT INTO `dsai_impu` VALUES (7,1,7,0);


INSERT INTO `imsu` VALUES (8,'thuyluu','','',1,1);
INSERT INTO `impu` VALUES (8,'sip:thuyluu@ims.sipify',0,0,0,1,8,1,'','',0,1);
INSERT INTO `impi` VALUES
(10,8,'thuyluu@ims.sipify','thuyluu',255,1,'\0\0',
 '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
 '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
 '000000000000','','',0,3600,1);
INSERT INTO `impi_impu` VALUES (10,10,8,0);
INSERT INTO `impu_visited_network` VALUES (8,8,2);
INSERT INTO `dsai_impu` VALUES (8,1,8,0);
