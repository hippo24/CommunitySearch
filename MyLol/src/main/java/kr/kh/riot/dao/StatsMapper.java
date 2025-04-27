package kr.kh.riot.dao;

import java.util.List;

import kr.kh.riot.model.vo.TftPlayers;
import kr.kh.riot.model.vo.TftRank;

public interface StatsMapper {
    List<TftPlayers> selectTftPlayers();
    List<TftRank> selectTftRank();
}