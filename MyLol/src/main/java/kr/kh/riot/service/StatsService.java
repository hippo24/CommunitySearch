package kr.kh.riot.service;

import java.util.List;

import kr.kh.riot.model.vo.TftPlayers;

public interface StatsService {
    List<TftPlayers> getTftPlayers();
}