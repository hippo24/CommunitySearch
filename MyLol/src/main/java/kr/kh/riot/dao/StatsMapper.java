package kr.kh.riot.dao;

import java.util.List;

import kr.kh.riot.model.vo.TftPlayers;

public interface StatsMapper {
    List<TftPlayers> selectTftPlayers();
}