package kr.kh.riot.model.vo;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.Data;

@Data
public class TftRank {
	private int id;
	private String riotIdName;
	private String riotIdTagline;
    private String tier;
    private String rankDivision;
    private int leaguePoints;
    private int wins;
    private int losses;
}