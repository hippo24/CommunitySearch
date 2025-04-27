package kr.kh.riot.dao;

import java.util.List;

import kr.kh.riot.model.vo.TftPlayer;

public interface StatsMapper {
    List<TftPlayer> selectTftPlayers();
}