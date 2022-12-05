package com.beanoung.crm.workbench.service;

import com.beanoung.crm.workbench.pojo.FunnelVO;

import java.util.List;

public interface TranService {
    List<FunnelVO> queryCountOfTranGroupByStage();
}
