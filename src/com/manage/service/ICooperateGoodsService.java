package com.manage.service;

import java.util.List;

import com.manage.dao.model.CooperateGoods;
import com.manage.dao.model.CooperateGoodsExample;

public interface ICooperateGoodsService {

	int countByExample(CooperateGoodsExample example);

    int deleteByExample(CooperateGoodsExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(CooperateGoods record);

    List<CooperateGoods> selectByExample(CooperateGoodsExample example);

    CooperateGoods selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(CooperateGoods record);

}
