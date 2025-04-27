package kr.kh.riot.service;

import java.util.List;

import kr.kh.riot.model.vo.TftMatches;
import kr.kh.riot.model.vo.TftPlayers;
import kr.kh.riot.model.vo.TftRank;

public interface StatsService {
    List<TftPlayers> getTftPlayers();
    List<TftRank> getTftRank();
    List<TftMatches> getTftMatches();
}