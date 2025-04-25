package kr.kh.riot.model.vo;

import java.util.Date;

import lombok.Data;

@Data
public class TFTMatcheVO {
	private int id;
	private String match_id;
	private String puuid;
	private int placement;
	private int level;
	private int gold_left;
	private int last_round;
	private int players_eliminated;
	private int time_eliminated;
	private int total_damage_to_players;
	private float game_length;
	private String companion;
	private String traits;
	private String units;
	private Date created_at;
	
}
