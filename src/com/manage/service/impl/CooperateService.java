package com.manage.service.impl;

import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.CooperateGoodsMapper;
import com.manage.dao.mapper.CooperateMapper;
import com.manage.dao.model.Cooperate;
import com.manage.dao.model.CooperateExample;
import com.manage.dao.model.CooperateGoods;
import com.manage.dao.model.CooperateGoodsExample;
import com.manage.service.ICooperateService;

@Service
public class CooperateService implements ICooperateService {

	@Autowired
	private CooperateMapper cooperateMapper;
	@Autowired
	private CooperateGoodsMapper cooperateGoodsMapper;
	
	public int countByExample(CooperateExample example) {
		return cooperateMapper.countByExample(example);
	}

	public int deleteByExample(CooperateExample example) {
		return cooperateMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return cooperateMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Cooperate record) {
		return cooperateMapper.insertSelective(record);
	}

	public List<Cooperate> selectByExampleWithBLOBs(CooperateExample example) {
		return cooperateMapper.selectByExampleWithBLOBs(example);
	}

	public List<Cooperate> selectByExample(CooperateExample example) {
		return cooperateMapper.selectByExample(example);
	}

	public Cooperate selectByPrimaryKey(Long id) {
		return cooperateMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(Cooperate record) {
		return cooperateMapper.updateByPrimaryKeySelective(record);
	}

	public int updateByPrimaryKeyWithBLOBs(Cooperate record) {
		return cooperateMapper.updateByPrimaryKeyWithBLOBs(record);
	}

	public boolean saveCooperate(Cooperate record, String json) {
		if(StringUtils.isBlank(json)){
			return false;
		}
		Date date=new Date();
		record.setUpdatetime(date);
		if(record.getId()==null){
			record.setCreatetime(date);
			cooperateMapper.insertSelective(record);
		}
		else{
			cooperateMapper.updateByPrimaryKeyWithBLOBs(record);
			
			CooperateGoodsExample cooperateGoodsExample=new CooperateGoodsExample();
			cooperateGoodsExample.createCriteria().andCooperateidEqualTo(record.getId());
			cooperateGoodsMapper.deleteByExample(cooperateGoodsExample);
		}
		JSONArray jsonArray=JSONArray.fromObject(json);
		for(int i=0;i<jsonArray.size();i++){
			String id=jsonArray.getString(i);
			CooperateGoods cooperateGoods=new CooperateGoods();
			cooperateGoods.setGoodsid(Long.parseLong(id));
			cooperateGoods.setCooperateid(record.getId());
			cooperateGoodsMapper.insertSelective(cooperateGoods);
		}
		
		return true;
	}

}
