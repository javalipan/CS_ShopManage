package com.manage.service.impl;

import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.BrandMapper;
import com.manage.dao.mapper.ImgsMapper;
import com.manage.dao.model.Brand;
import com.manage.dao.model.BrandExample;
import com.manage.dao.model.Imgs;
import com.manage.dao.model.ImgsExample;
import com.manage.service.IBrandService;

@Service
public class BrandService implements IBrandService {

	@Autowired
	private BrandMapper brandMapper;
	@Autowired
	private ImgsMapper imgsMapper;
	
	public int countByExample(BrandExample example) {
		return brandMapper.countByExample(example);
	}

	public int deleteByExample(BrandExample example) {
		return brandMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return brandMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Brand record) {
		return brandMapper.insertSelective(record);
	}

	public List<Brand> selectByExample(BrandExample example) {
		return brandMapper.selectByExample(example);
	}

	public Brand selectByPrimaryKey(Long id) {
		return brandMapper.selectByPrimaryKey(id);
	}
	
	public int updateByExampleSelective(Brand record, BrandExample example) {
		return brandMapper.updateByExampleSelective(record, example);
	}

	public int updateByPrimaryKeySelective(Brand record) {
		return brandMapper.updateByPrimaryKeySelective(record);
	}

	public boolean saveBrand(Brand brand, String imgJson) {
		if(StringUtils.isNotBlank(imgJson)){
			JSONArray jsonArray=JSONArray.fromObject(imgJson);
			if(jsonArray.size()>0){
				brand.setImg(jsonArray.getString(0));
			}
		}
		if(brand.getId()!=null){
			brand.setUpdatetime(new Date());
			brandMapper.updateByPrimaryKeySelective(brand);
			if(StringUtils.isNotBlank(imgJson)){
				JSONArray jsonArray=JSONArray.fromObject(imgJson);
				if(jsonArray.size()>0){
					ImgsExample imgsExample=new ImgsExample();
					imgsExample.createCriteria().andReceiptidEqualTo(brand.getId()).andTypeEqualTo("0");
					imgsMapper.deleteByExample(imgsExample);
					
					for(int i=0;i<jsonArray.size();i++){
						Imgs imgs=new Imgs();
						imgs.setReceiptid(brand.getId());
						imgs.setType("0");
						imgs.setPath(jsonArray.getString(i));
						imgsMapper.insertSelective(imgs);
					}
				}
			}
		}
		else{
			brand.setCreatetime(new Date());
			brand.setUpdatetime(new Date());
			brand.setStatus("0");
			brandMapper.insertSelective(brand);
			if(StringUtils.isNotBlank(imgJson)){
				JSONArray jsonArray=JSONArray.fromObject(imgJson);
				for(int i=0;i<jsonArray.size();i++){
					Imgs imgs=new Imgs();
					imgs.setReceiptid(brand.getId());
					imgs.setType("0");
					imgs.setPath(jsonArray.getString(i));
					imgsMapper.insertSelective(imgs);
				}
			}
		}
		return true;
	}

}
