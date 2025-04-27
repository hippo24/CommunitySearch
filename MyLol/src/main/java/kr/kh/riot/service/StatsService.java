package kr.kh.riot.service;

import java.util.List;

import kr.kh.riot.model.vo.TftPlayer;

public interface StatsService {
    List<TftPlayer> getTftPlayers();
}