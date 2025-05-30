# https://www.erdcloud.com/d/7sC2zZvewC6wtY9kb
# GROUP BY 할때 사용하지 않은 속성 조회하는 경우 에러 해결하는 쿼리(실행하고 인스턴스 나갔다 들어와야 적용됨)
SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';	
# 원상 복구하는 쿼리
# SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION,ONLY_FULL_GROUP_BY';	

DROP DATABASE IF EXISTS RIOT;


CREATE DATABASE RIOT;

USE RIOT;

# 유저
DROP TABLE IF EXISTS USER;
CREATE TABLE `USER` (
    `US_KEY` INT PRIMARY KEY AUTO_INCREMENT,
    `US_ID` VARCHAR(255) UNIQUE NOT NULL,
    `US_PW` VARCHAR(255) NOT NULL,
    `US_NAME` VARCHAR(255) NOT NULL,
	`US_EMAIL` VARCHAR(255) NOT NULL,
    `US_CREATE` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `US_AUTHORITY` VARCHAR(5) DEFAULT 'USER' NOT NULL,
    `US_COOKIE` VARCHAR(255),
    `US_LIMIT` DATETIME
);

# 검색된 소환사 
DROP TABLE IF EXISTS SUMMONER_SEARCHED;
CREATE TABLE `SUMMONER_SEARCHED` (
    `SS_KEY` INT PRIMARY KEY AUTO_INCREMENT,
    `SS_SMMNR` VARCHAR(255) NOT NULL,
    `SS_TAG` VARCHAR(255) NOT NULL,
	`SS_PUUID` VARCHAR(255) NOT NULL,
    `SS_LEVEL` INT NOT NULL,
    `SS_UPD`  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


# 연동 정보
DROP TABLE IF EXISTS GRANTED_INFO;
CREATE TABLE `GRANTED_INFO` (
	`GI_KEY` INT PRIMARY KEY AUTO_INCREMENT,
    `GI_US_KEY` INT NOT NULL,
    `GI_SS_KEY` INT NOT NULL
);



# 게시판 
DROP TABLE IF EXISTS BOARD;
CREATE TABLE `BOARD` (
	`BO_KEY` INT PRIMARY KEY AUTO_INCREMENT,
    `BO_NAME` VARCHAR(100) NOT NULL
);

# 게시글
DROP TABLE IF EXISTS POST;
CREATE TABLE `POST` (
	`PO_KEY` INT PRIMARY KEY AUTO_INCREMENT,
    `PO_US_KEY` INT NOT NULL,
    `PO_BO_KEY` INT NOT NULL,
    `PO_TYPE` ENUM("LOL","TFT","ALL"),
    `PO_TITLE` VARCHAR(100) NOT NULL,
    `PO_CONTENT` LONGTEXT NOT NULL,
    `PO_TIME` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `PO_UPD` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

# 댓글
DROP TABLE IF EXISTS `COMMENT`;
CREATE TABLE `COMMENT` (
	`CO_KEY` INT PRIMARY KEY AUTO_INCREMENT,
    `CO_PO_KEY` INT NOT NULL,
    `CO_US_KEY` INT NOT NULL,
    `CO_ORI_KEY` INT NOT NULL,
    `CO_CONTENT` LONGTEXT NOT NULL,
    `CO_TIME` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `CO_UPD` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `CO_ANO` INT 
);


# 추천 비추천 
DROP TABLE IF EXISTS `RECOMMENDED`;
CREATE TABLE `RECOMMENDED` (
	`REC_KEY` INT PRIMARY KEY AUTO_INCREMENT,
    `REC_PO_KEY` INT NOT NULL,
    `REC_US_KEY` INT NOT NULL,
    `REC_STATE` TINYINT NOT NULL DEFAULT 0
);

# 듀오 모집 게시글 
DROP TABLE IF EXISTS `POSITION_BOARD`;
CREATE TABLE `POSITION_BOARD` (
	`PB_KEY` INT PRIMARY KEY AUTO_INCREMENT,
    `PB_US_KEY` INT NOT NULL,
    `PB_STATE` TINYINT NOT NULL DEFAULT 0,
    `PB_CONTENT` VARCHAR(255) NOT NULL DEFAULT "",
    `PB_TIME` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `PB_UPD` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

# 듀오 모집 시 포지션 
DROP TABLE IF EXISTS `POSITION`;
CREATE TABLE `POSITION` (
	`PS_KEY` INT PRIMARY KEY AUTO_INCREMENT,
    `PS_PB_KEY` INT NOT NULL,
    `PS_ORDER` TINYINT NOT NULL,
    `PS_LINE` ENUM("TOP","JNG","MID","ADC","SPT") NOT NULL
);


# 첨부파일(추가)
DROP TABLE IF EXISTS `FILE`;

CREATE TABLE `FILE` (
	`fi_key`	int  primary key auto_increment,
	`fi_ori_name`	varchar(255) not	NULL,
	`fi_name`	varchar(255) not	NULL,
	`fi_po_key`	int	NOT NULL
);

# 이메일 인증(추가)
DROP TABLE IF EXISTS `email_verification`;
CREATE TABLE `email_verification` (
    ev_key INT AUTO_INCREMENT PRIMARY KEY,
    ev_email VARCHAR(255) NOT NULL,
    ev_authCode VARCHAR(255) NOT NULL,
    ev_created DATETIME DEFAULT CURRENT_TIMESTAMP,
    ev_verified BOOLEAN DEFAULT FALSE,
    ev_expired BOOLEAN DEFAULT FALSE
);


# 외래키 등록


# 댓글 외래키
ALTER TABLE `COMMENT` ADD CONSTRAINT `FK_POST_TO_COMMENT_1` FOREIGN KEY (
	`CO_PO_KEY`
)
REFERENCES `POST` (
	`PO_KEY`
);
ALTER TABLE `COMMENT` ADD CONSTRAINT `FK_USER_TO_COMMENT_1` FOREIGN KEY (
	`CO_US_KEY`
)
REFERENCES `USER` (
	`US_KEY`
);

# 게시글 외래키
ALTER TABLE `POST` ADD CONSTRAINT `FK_USER_TO_POST_1` FOREIGN KEY (
	`PO_US_KEY`
)
REFERENCES `USER` (
	`US_KEY`
);
ALTER TABLE `POST` ADD CONSTRAINT `FK_BOARD_TO_POST_1` FOREIGN KEY (
	`PO_BO_KEY`
)
REFERENCES `BOARD` (
	`BO_KEY`
);

# 추천비추천 외래키
ALTER TABLE `RECOMMENDED` ADD CONSTRAINT `FK_POST_TO_RECOMMENDED_1` FOREIGN KEY (
	`REC_PO_KEY`
)
REFERENCES `POST` (
	`PO_KEY`
);
ALTER TABLE `RECOMMENDED` ADD CONSTRAINT `FK_USER_TO_RECOMMENDED_1` FOREIGN KEY (
	`REC_US_KEY`
)
REFERENCES `USER` (
	`US_KEY`
);

# 듀오 모집 게시글 외래키 
ALTER TABLE `POSITION_BOARD` ADD CONSTRAINT `FK_USER_TO_POSITION_BOARD_1` FOREIGN KEY (
	`PB_US_KEY`
)
REFERENCES `USER` (
	`US_KEY`
);

# 듀오 모집 외래키 
ALTER TABLE `POSITION` ADD CONSTRAINT `FK_POSITION_BOARD_TO_POSITION_1` FOREIGN KEY (
	`PS_PB_KEY`
)
REFERENCES `POSITION_BOARD` (
	`PB_KEY`
);




# 연동된 소환사 외래키
ALTER TABLE `GRANTED_INFO` ADD CONSTRAINT `FK_USER_TO_GRANTED_INFO_1` FOREIGN KEY (
	`GI_US_KEY`
)
REFERENCES `USER` (
	`US_KEY`
);
ALTER TABLE `GRANTED_INFO` ADD CONSTRAINT `FK_SUMMONER_SEARCHED_TO_GRANTED_INFO_1` FOREIGN KEY (
	`GI_SS_KEY`
)
REFERENCES `SUMMONER_SEARCHED` (
	`SS_KEY`
);


#차후 추가된 파일 외래키
ALTER TABLE `FILE` ADD CONSTRAINT `FK_POST_TO_FILE_1` FOREIGN KEY (
	`fi_po_key`
)
REFERENCES `POST` (
	`po_key`
);
