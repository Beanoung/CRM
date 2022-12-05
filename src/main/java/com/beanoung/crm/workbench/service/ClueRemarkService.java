package com.beanoung.crm.workbench.service;

import com.beanoung.crm.workbench.pojo.ClueRemark;

import java.util.List;

public interface ClueRemarkService {

    List<ClueRemark> queryAllClueRemarkByClueId(String clueId);

    int saveCreateClueRemark(ClueRemark clueRemark);
}
