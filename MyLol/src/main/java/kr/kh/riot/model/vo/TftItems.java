package kr.kh.riot.model.vo;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.Data;

@Data
public class TftItems {
	private int id;
    private String matchId;
    private String puuid;
    private String riotIdName;      // 조인 결과로 받을 값
    private String riotIdTagline;   // 조인 결과로 받을 값
    private int unitIndex;
    private String unitName;
    private String itemName;
}