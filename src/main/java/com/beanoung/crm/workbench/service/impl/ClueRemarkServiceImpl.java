package com.beanoung.crm.workbench.service.impl;

import com.beanoung.crm.workbench.mapper.ClueRemarkMapper;
import com.beanoung.crm.workbench.pojo.ClueRemark;
import com.beanoung.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> queryAllClueRemarkByClueId(String clueId) {
        return clueRemarkMapper.selectAllClueRemarkByClueId(clueId);
    }

    @Override
    public int saveCreateClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertClueRemark(clueRemark);
    }
}
