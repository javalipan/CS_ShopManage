package com.manage.service.impl;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.manage.dao.mapper.GoodsDetailMapper;
import com.manage.dao.mapper.GoodsMapper;
import com.manage.dao.mapper.ImgsMapper;
import com.manage.dao.mapper.RepertoryMapper;
import com.manage.dao.mapper.SpecMapper;
import com.manage.dao.model.Goods;
import com.manage.dao.model.GoodsDetail;
import com.manage.dao.model.GoodsDetailExample;
import com.manage.dao.model.GoodsExample;
import com.manage.dao.model.Imgs;
import com.manage.dao.model.ImgsExample;
import com.manage.dao.model.Repertory;
import com.manage.dao.model.User;
import com.manage.query.mapper.GoodsQueryMapper;
import com.manage.query.model.GoodsQuery;
import com.manage.service.IGoodsService;
import com.manage.util.ArrayUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service
public class GoodsService implements IGoodsService {

	@Autowired
	private GoodsMapper goodsMapper;
	@Autowired
	private GoodsQueryMapper goodsQueryMapper;
	@Autowired
	private ImgsMapper imgsMapper;
	@Autowired
	private GoodsDetailMapper goodsDetailMapper;
	@Autowired
	private RepertoryMapper repertoryMapper;
	@Autowired
	private SpecMapper specMapper;
	
	public int countByExample(GoodsExample example) {
		return goodsMapper.countByExample(example);
	}

	public int deleteByExample(GoodsExample example) {
		return goodsMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return goodsMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Goods record) {
		return goodsMapper.insertSelective(record);
	}

	public List<Goods> selectByExampleWithBLOBs(GoodsExample example) {
		return goodsMapper.selectByExampleWithBLOBs(example);
	}

	public List<Goods> selectByExample(GoodsExample example) {
		return goodsMapper.selectByExample(example);
	}

	public Goods selectByPrimaryKey(Long id) {
		return goodsMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(Goods record) {
		return goodsMapper.updateByPrimaryKeySelective(record);
	}

	public int updateByExampleSelective(Goods record, GoodsExample example) {
		return goodsMapper.updateByExampleSelective(record, example);
	}

	public boolean saveGoods(Goods goods, String detailJson, String imgJson) {
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest(); 
		User user= (User) request.getSession().getAttribute("USER_INFO");
		if(StringUtils.isNotBlank(imgJson)){
			JSONArray jsonArray=JSONArray.fromObject(imgJson);
			if(jsonArray.size()>0){
				goods.setImg(jsonArray.getString(0));
			}
		}
		if(goods.getId()!=null){		//修改
			Goods temp=goodsMapper.selectByPrimaryKey(goods.getId());
			goods.setUpdatetime(new Date());
			goodsMapper.updateByPrimaryKeySelective(goods);
			if(StringUtils.isNotBlank(imgJson)){
				JSONArray jsonArray=JSONArray.fromObject(imgJson);
				if(jsonArray.size()>0){
					ImgsExample imgsExample=new ImgsExample();
					imgsExample.createCriteria().andReceiptidEqualTo(goods.getId()).andTypeEqualTo("1");
					imgsMapper.deleteByExample(imgsExample);
					
					for(int i=0;i<jsonArray.size();i++){
						Imgs imgs=new Imgs();
						imgs.setReceiptid(goods.getId());
						imgs.setType("1");
						imgs.setPath(jsonArray.getString(i));
						imgsMapper.insertSelective(imgs);
					}
				}
			}
			
			if(StringUtils.isNotBlank(detailJson)){
				JSONArray jsonArray=JSONArray.fromObject(detailJson);
				JSONObject priceJson=new JSONObject();
				JSONArray pricejsonArray=new JSONArray();
				JSONArray sizeJson=new JSONArray();
				JSONArray colorJson=new JSONArray();
				double[] pricearray=new double[jsonArray.size()];
				double[] vippricearray=new double[jsonArray.size()];
				for(int i=0;i<jsonArray.size();i++){
					JSONObject detail=jsonArray.getJSONObject(i);
					GoodsDetail goodsDetail=new GoodsDetail();
					goodsDetail.setGoodsid(goods.getId());
					goodsDetail.setDetailcode(detail.getString("code"));
					goodsDetail.setSizeid(detail.getLong("size"));
					goodsDetail.setColorid(detail.getLong("color"));
					goodsDetail.setCostprice(detail.getDouble("costprice"));
					goodsDetail.setOldprice(detail.getDouble("oldprice"));
					goodsDetail.setPrice(detail.getDouble("price"));
					goodsDetail.setVipprice(detail.getDouble("vipprice"));
					String status=detail.getString("status");
					if("1".equals(status)){
						goods.setStatus("1");
					}
					goodsDetail.setStatus(status);
					goodsDetail.setUpdatetime(new Date());
					if(detail.has("id")){
						goodsDetail.setId(detail.getLong("id"));
						goodsDetailMapper.updateByPrimaryKeySelective(goodsDetail);
					}
					else{
						int amount=detail.getInt("amount");
						goodsDetail.setAmount(amount);
						goodsDetailMapper.insertSelective(goodsDetail);
						
						if(amount>0){	//数量大于0，生成入库记录
							Repertory repertory=new Repertory();
							repertory.setGoodsdetailid(goodsDetail.getId());
							repertory.setBeforeamount(0);
							repertory.setAmount(goodsDetail.getAmount());
							repertory.setAfteramount(goodsDetail.getAmount());
							repertory.setIntime(new Date());
							repertory.setOperator(user.getId());
							repertoryMapper.insertSelective(repertory);
						}
					}
					
					//拼装价格json
					pricearray[i]=detail.getDouble("price");
					if("2".equals(temp.getIsdiscount())){
						vippricearray[i]=goodsDetail.getVipprice();
					}
					JSONObject price=new JSONObject();
					price.put("id", goodsDetail.getId());
					price.put("price", goodsDetail.getPrice());
					pricejsonArray.add(price);
					
					//拼装规格json
					boolean sizeFlag=true;
					for(int j=0;j<sizeJson.size();j++){
						if(sizeJson.getJSONObject(j).getLong("id")==detail.getLong("size")){
							sizeFlag=false;
						}
					}
					if(sizeFlag&&"1".equals(goodsDetail.getStatus())){
						JSONObject obj=new JSONObject();
						obj.put("id", detail.getLong("size"));
						obj.put("name", specMapper.selectByPrimaryKey(detail.getLong("size")).getSpecvalue());
						sizeJson.add(obj);
					}
					boolean colorFlag=true;
					for(int j=0;j<colorJson.size();j++){
						if(colorJson.getJSONObject(j).getLong("id")==detail.getLong("color")){
							colorFlag=false;
						}
					}
					if(colorFlag&&"1".equals(goodsDetail.getStatus())){
						JSONObject obj=new JSONObject();
						obj.put("id", detail.getLong("color"));
						obj.put("name", specMapper.selectByPrimaryKey(detail.getLong("color")).getSpecvalue());
						colorJson.add(obj);
					}
				}
				Arrays.sort(pricearray);
				priceJson.put("min", pricearray[0]);
				priceJson.put("max", pricearray[pricearray.length-1]);
				if("2".equals(temp.getIsdiscount())){
					Arrays.sort(vippricearray);
					priceJson.put("vipmin", vippricearray[0]);
					priceJson.put("vipmax", vippricearray[vippricearray.length-1]);
					goods.setMinprice(vippricearray[0]);
				}
				else{
					goods.setMinprice(pricearray[0]);
				}
				priceJson.put("prices", pricejsonArray);
				goods.setPricejson(priceJson.toString());		//价格json
				JSONObject specJson=new JSONObject();
				specJson.put("size", sizeJson);
				specJson.put("color", colorJson);
				goods.setSpecjson(specJson.toString());
				goods.setGoodsSeason(("0".equals(goods.getSeason())||"1".equals(goods.getSeason()))?"SS":"AW");
				goodsMapper.updateByPrimaryKeySelective(goods);
				
			}
		}
		else{		//新增
			goods.setCreatetime(new Date());
			goods.setUpdatetime(new Date());
			goods.setStatus("0");
			goods.setClickcnt((long)0);
			goods.setGoodsSeason(("0".equals(goods.getSeason())||"1".equals(goods.getSeason()))?"SS":"AW");
			goodsMapper.insertSelective(goods);
			if(StringUtils.isNotBlank(imgJson)){
				JSONArray jsonArray=JSONArray.fromObject(imgJson);
				for(int i=0;i<jsonArray.size();i++){
					Imgs imgs=new Imgs();
					imgs.setReceiptid(goods.getId());
					imgs.setType("1");
					imgs.setPath(jsonArray.getString(i));
					imgsMapper.insertSelective(imgs);
				}
			}
			
			if(StringUtils.isNotBlank(detailJson)){
				JSONArray jsonArray=JSONArray.fromObject(detailJson);
				JSONObject priceJson=new JSONObject();
				JSONArray pricejsonArray=new JSONArray();
				double[] pricearray=new double[jsonArray.size()];
				JSONArray sizeJson=new JSONArray();
				JSONArray colorJson=new JSONArray();
				for(int i=0;i<jsonArray.size();i++){
					JSONObject detail=jsonArray.getJSONObject(i);
					GoodsDetail goodsDetail=new GoodsDetail();
					goodsDetail.setGoodsid(goods.getId());
					goodsDetail.setDetailcode(detail.getString("code"));
					goodsDetail.setSizeid(detail.getLong("size"));
					goodsDetail.setColorid(detail.getLong("color"));
					goodsDetail.setCostprice(detail.getDouble("costprice"));
					goodsDetail.setOldprice(detail.getDouble("oldprice"));
					goodsDetail.setPrice(detail.getDouble("price"));
					goodsDetail.setVipprice(detail.getDouble("vipprice"));
					int amount=detail.getInt("amount");
					goodsDetail.setAmount(amount);
					String status=detail.getString("status");
					if("1".equals(status)){
						goods.setStatus("1");
					}
					goodsDetail.setStatus(status);
					goodsDetail.setUpdatetime(new Date());
					goodsDetailMapper.insertSelective(goodsDetail);
					
					//拼装价格json
					pricearray[i]=detail.getDouble("price");
					JSONObject price=new JSONObject();
					price.put("id", goodsDetail.getId());
					price.put("price", goodsDetail.getPrice());
					pricejsonArray.add(price);
					
					//拼装规格json
					boolean sizeFlag=true;
					for(int j=0;j<sizeJson.size();j++){
						if(sizeJson.getJSONObject(j).getLong("id")==detail.getLong("size")){
							sizeFlag=false;
						}
					}
					if(sizeFlag&&"1".equals(goodsDetail.getStatus())){
						JSONObject obj=new JSONObject();
						obj.put("id", detail.getLong("size"));
						obj.put("name", specMapper.selectByPrimaryKey(detail.getLong("size")).getSpecvalue());
						sizeJson.add(obj);
					}
					boolean colorFlag=true;
					for(int j=0;j<colorJson.size();j++){
						if(colorJson.getJSONObject(j).getLong("id")==detail.getLong("color")){
							colorFlag=false;
						}
					}
					if(colorFlag&&"1".equals(goodsDetail.getStatus())){
						JSONObject obj=new JSONObject();
						obj.put("id", detail.getLong("color"));
						obj.put("name", specMapper.selectByPrimaryKey(detail.getLong("color")).getSpecvalue());
						colorJson.add(obj);
					}
					
					if(amount>0){		//库存大于0,生成入库记录
						Repertory repertory=new Repertory();
						repertory.setGoodsdetailid(goodsDetail.getId());
						repertory.setBeforeamount(0);
						repertory.setAmount(goodsDetail.getAmount());
						repertory.setAfteramount(goodsDetail.getAmount());
						repertory.setIntime(new Date());
						repertory.setOperator(user.getId());
						repertoryMapper.insertSelective(repertory);
					}
				}
				
				Arrays.sort(pricearray);
				priceJson.put("min", pricearray[0]);
				priceJson.put("max", pricearray[pricearray.length-1]);
				priceJson.put("prices", pricejsonArray);
				goods.setPricejson(priceJson.toString());		//价格json
				goods.setMinprice(pricearray[0]);
				JSONObject specJson=new JSONObject();
				specJson.put("size", sizeJson);
				specJson.put("color", colorJson);
				goods.setSpecjson(specJson.toString());
				goodsMapper.updateByPrimaryKeySelective(goods);
			}
		}
		return true;
	}

	public GoodsQuery selectGoodsQueryById(Long id) {
		return goodsQueryMapper.selectGoodsQueryById(id);
	}

	public List<GoodsQuery> selectByGoodsQuery(GoodsQuery goodsQuery) {
		return goodsQueryMapper.selectByGoodsQuery(goodsQuery);
	}

	public Integer countByGoodsQuery(GoodsQuery goodsQuery) {
		return goodsQueryMapper.countByGoodsQuery(goodsQuery);
	}

	public boolean updateGoodsStatus(String ids, String status) {
		List<Long> idlist=ArrayUtil.idsToLongList(ids);
		GoodsExample goodsExample=new GoodsExample();
		goodsExample.createCriteria().andIdIn(idlist);
		Goods goods=new Goods();
		goods.setStatus(status);
		goodsMapper.updateByExampleSelective(goods, goodsExample);
		
		GoodsDetailExample goodsDetailExample=new GoodsDetailExample();
		goodsDetailExample.createCriteria().andGoodsidIn(idlist);
		GoodsDetail goodsDetail=new GoodsDetail();
		goodsDetail.setStatus(status);
		goodsDetailMapper.updateByExampleSelective(goodsDetail, goodsDetailExample);
		
		for(Long id:idlist){
			updateSpec(id, status);
		}
		return false;
	}
	
	@Async
	private void updateSpec(Long id,String status){
		GoodsDetailExample goodsDetailExample=new GoodsDetailExample();
		goodsDetailExample.createCriteria().andGoodsidEqualTo(id).andStatusEqualTo("1");
		List<GoodsDetail> goodsDetails=goodsDetailMapper.selectByExample(goodsDetailExample);		//已上架商品
		Goods goods=new Goods();
		goods.setId(id);
		JSONArray sizeJson=new JSONArray();
		JSONArray colorJson=new JSONArray();
		for(int i=0;i<goodsDetails.size();i++){
			//拼装规格json
			boolean sizeFlag=true;
			for(int j=0;j<sizeJson.size();j++){
				if(sizeJson.getJSONObject(j).getLong("id")==goodsDetails.get(i).getSizeid()){
					sizeFlag=false;
				}
			}
			if(sizeFlag){
				JSONObject obj=new JSONObject();
				obj.put("id", goodsDetails.get(i).getSizeid());
				obj.put("name", specMapper.selectByPrimaryKey(goodsDetails.get(i).getSizeid()).getSpecvalue());
				sizeJson.add(obj);
			}
			boolean colorFlag=true;
			for(int j=0;j<colorJson.size();j++){
				if(colorJson.getJSONObject(j).getLong("id")==goodsDetails.get(i).getColorid()){
					colorFlag=false;
				}
			}
			if(colorFlag){
				JSONObject obj=new JSONObject();
				obj.put("id", goodsDetails.get(i).getColorid());
				obj.put("name", specMapper.selectByPrimaryKey(goodsDetails.get(i).getColorid()).getSpecvalue());
				colorJson.add(obj);
			}
		}
		JSONObject specJson=new JSONObject();
		specJson.put("size", sizeJson);
		specJson.put("color", colorJson);
		goods.setSpecjson(specJson.toString());
		goodsMapper.updateByPrimaryKeySelective(goods);		//修改商品状态为上架
	}

	public GoodsQuery selectGoodsQueryByCode(String code) {
		return goodsQueryMapper.selectGoodsQueryByCode(code);
	}

	public List<GoodsQuery> selectSumByGoodsQuery(GoodsQuery goodsQuery) {
		return goodsQueryMapper.selectSumByGoodsQuery(goodsQuery);
	}

	public boolean updateDetailStatus(Long id, String status) {
		GoodsDetail goodsDetail=new GoodsDetail();
		goodsDetail.setId(id);
		goodsDetail.setStatus(status);
		GoodsDetail gd=goodsDetailMapper.selectByPrimaryKey(id);
		goodsDetailMapper.updateByPrimaryKeySelective(goodsDetail);
		
		GoodsDetailExample goodsDetailExample=new GoodsDetailExample();
		goodsDetailExample.createCriteria().andGoodsidEqualTo(gd.getGoodsid()).andStatusEqualTo("1");
		List<GoodsDetail> goodsDetails=goodsDetailMapper.selectByExample(goodsDetailExample);		//已上架商品
		
		Goods goods=new Goods();
		goods.setId(gd.getGoodsid());
		JSONArray sizeJson=new JSONArray();
		JSONArray colorJson=new JSONArray();
		for(int i=0;i<goodsDetails.size();i++){
			//拼装规格json
			boolean sizeFlag=true;
			for(int j=0;j<sizeJson.size();j++){
				if(sizeJson.getJSONObject(j).getLong("id")==goodsDetails.get(i).getSizeid()){
					sizeFlag=false;
				}
			}
			if(sizeFlag&&"1".equals(goodsDetail.getStatus())){
				JSONObject obj=new JSONObject();
				obj.put("id", goodsDetails.get(i).getSizeid());
				obj.put("name", specMapper.selectByPrimaryKey(goodsDetails.get(i).getSizeid()).getSpecvalue());
				sizeJson.add(obj);
			}
			boolean colorFlag=true;
			for(int j=0;j<colorJson.size();j++){
				if(colorJson.getJSONObject(j).getLong("id")==goodsDetails.get(i).getColorid()){
					colorFlag=false;
				}
			}
			if(colorFlag&&"1".equals(goodsDetail.getStatus())){
				JSONObject obj=new JSONObject();
				obj.put("id", goodsDetails.get(i).getColorid());
				obj.put("name", specMapper.selectByPrimaryKey(goodsDetails.get(i).getColorid()).getSpecvalue());
				colorJson.add(obj);
			}
		}
		JSONObject specJson=new JSONObject();
		specJson.put("size", sizeJson);
		specJson.put("color", colorJson);
		goods.setSpecjson(specJson.toString());
		if("1".equals(status)){
			goods.setStatus("1");
			goodsMapper.updateByPrimaryKeySelective(goods);		//修改商品状态为上架
		}
		else{
			if(goodsDetails.size()<=0){
				goods.setStatus("2");
			}
			goodsMapper.updateByPrimaryKeySelective(goods);		//所有详情下架，下架商品
		}
		return true;
	}

}
