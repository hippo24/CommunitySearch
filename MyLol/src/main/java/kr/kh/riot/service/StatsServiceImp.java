package kr.kh.riot.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.kh.riot.dao.StatsMapper;
import kr.kh.riot.model.vo.TftItems;
import kr.kh.riot.model.vo.TftMatches;
import kr.kh.riot.model.vo.TftPlayers;
import kr.kh.riot.model.vo.TftRank;

@Service
public class StatsServiceImp implements StatsService {
    @Autowired
    private StatsMapper statsMapper;

    @Override
    public List<TftPlayers> getTftPlayers() {
        return statsMapper.selectTftPlayers();
    }
    @Override
    public List<TftRank> getTftRank() {
        return statsMapper.selectTftRank();
    }
    @Override
    public List<TftMatches> getTftMatches() {
        return statsMapper.selectTftMatches();
    }
    @Override
    public List<TftItems> getTftItems() {
        return statsMapper.selectTftItems();
    }
    
    @Override
    public List<TftPlayers> getTftPlayersByRiotId(String riotIdName, String riotIdTagline) {
        return statsMapper.selectTftPlayersByRiotId(riotIdName, riotIdTagline);
    }

    @Override
    public List<TftRank> getTftRankByRiotId(String riotIdName, String riotIdTagline) {
        return statsMapper.selectTftRankByRiotId(riotIdName, riotIdTagline);
    }

    @Override
    public List<TftMatches> getTftMatchesByRiotId(String riotIdName, String riotIdTagline) {
        return statsMapper.selectTftMatchesByRiotId(riotIdName, riotIdTagline);
    }

    @Override
    public List<TftItems> getTftItemsByRiotId(String riotIdName, String riotIdTagline) {
        return statsMapper.selectTftItemsByRiotId(riotIdName, riotIdTagline);
    }
    @Override
    public List<Map<String, Object>> getTop3UnitsByRiotId(String riotIdName, String riotIdTagline) {
        return statsMapper.selectTop3UnitsByRiotId(riotIdName, riotIdTagline);
    }
    @Override
    public List<Map<String, Object>> getTop3TraitsByRiotId(String riotIdName, String riotIdTagline) {
        return statsMapper.selectTop3TraitsByRiotId(riotIdName, riotIdTagline);
    }
    @Override
    public List<Map<String, Object>> getTop3ItemsByRiotId(String riotIdName, String riotIdTagline) {
        return statsMapper.selectTop3ItemsByRiotId(riotIdName, riotIdTagline);
    }
    @Override
    public List<Map<String, Object>> getTierCountByRiotId(String riotIdName, String riotIdTagline) {
        return statsMapper.selectTierCountByRiotId(riotIdName, riotIdTagline);
    }
}