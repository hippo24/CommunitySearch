package kr.kh.riot.model.vo;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.Data;

@Data
public class TftPlayer {
    private int id;
    private String puuid;
    private String riotIdName;
    private String riotIdTagline;
    private Date gameDate;
    private Timestamp createdAt;
    private boolean bot;
}