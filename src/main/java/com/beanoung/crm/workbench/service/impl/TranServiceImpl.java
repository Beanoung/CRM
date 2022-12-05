package com.beanoung.crm.workbench.service.impl;

import com.beanoung.crm.workbench.mapper.TranMapper;
import com.beanoung.crm.workbench.pojo.FunnelVO;
import com.beanoung.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private TranMapper tranMapper;

    @Override
    public List<FunnelVO> queryCountOfTranGroupByStage() {
        return tranMapper.selectCountOfTranGroupByStage();
    }
}
