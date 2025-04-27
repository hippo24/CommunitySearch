package kr.kh.riot.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.kh.riot.dao.StatsMapper;
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
}