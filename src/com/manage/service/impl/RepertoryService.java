package com.manage.service.impl;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.manage.dao.mapper.GoodsDetailMapper;
import com.manage.dao.mapper.RepertoryMapper;
import com.manage.dao.model.GoodsDetail;
import com.manage.dao.model.Repertory;
import com.manage.dao.model.RepertoryExample;
import com.manage.dao.model.User;
import com.manage.query.mapper.RepertoryQueryMapper;
import com.manage.query.model.RepertoryQuery;
import com.manage.service.IRepertoryService;

@Service
public class RepertoryService implements IRepertoryService {

	@Autowired
	private RepertoryMapper repertoryMapper;
	@Autowired
	private RepertoryQueryMapper repertoryQueryMapper;
	@Autowired
	private GoodsDetailMapper goodsDetailMapper;
	
	public int countByExample(RepertoryExample example) {
		return repertoryMapper.countByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return repertoryMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Repertory record) {
		return repertoryMapper.insertSelective(record);
	}

	public List<Repertory> selectByExample(RepertoryExample example) {
		return repertoryMapper.selectByExample(example);
	}

	public Repertory selectByPrimaryKey(Long id) {
		return repertoryMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(Repertory record) {
		return repertoryMapper.updateByPrimaryKeySelective(record);
	}

	public List<RepertoryQuery> selectByRepertoryQuery(
			RepertoryQuery repertoryQuery) {
		return repertoryQueryMapper.selectByRepertoryQuery(repertoryQuery);
	}

	public Integer countByRepertoryQuery(RepertoryQuery repertoryQuery) {
		return repertoryQueryMapper.countByRepertoryQuery(repertoryQuery);
	}

	public boolean saveRepertory(String json) {
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest(); 
		User user= (User) request.getSession().getAttribute("USER_INFO");
		if(StringUtils.isBlank(json)||"[]".equals(json)){
			return false;
		}
		JSONArray jsonArray=JSONArray.fromObject(json);
		for(int i=0;i<jsonArray.size();i++){
			JSONObject obj=jsonArray.getJSONObject(i);
			Repertory repertory=new Repertory();
			Long detailid=obj.getLong("id");
			int amount=obj.getInt("amount");
			GoodsDetail goodsDetail=goodsDetailMapper.selectByPrimaryKey(detailid);
			repertory.setGoodsdetailid(detailid);
			repertory.setBeforeamount(goodsDetail.getAmount());
			repertory.setAmount(amount);
			repertory.setAfteramount(goodsDetail.getAmount()+amount);
			repertory.setIntime(new Date());
			repertory.setOperator(user.getId());
			repertoryMapper.insertSelective(repertory);
			
			goodsDetail.setAmount(goodsDetail.getAmount()+amount);
			goodsDetailMapper.updateByPrimaryKeySelective(goodsDetail);
		}
		return true;
	}

	public int deleteByExample(RepertoryExample example) {
		return repertoryMapper.deleteByExample(example);
	}

}
