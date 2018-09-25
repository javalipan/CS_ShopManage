package com.manage.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.GoodsDetailMapper;
import com.manage.dao.mapper.GoodsMapper;
import com.manage.dao.model.Goods;
import com.manage.dao.model.GoodsDetail;
import com.manage.dao.model.GoodsDetailExample;
import com.manage.query.mapper.DiscountQueryMapper;
import com.manage.query.model.DiscountQuery;
import com.manage.service.IDiscountQueryService;
import com.manage.util.DateUtil;
import com.manage.util.NumberUtil;

@Service
public class DiscountQueryService implements IDiscountQueryService {

	@Autowired
	private DiscountQueryMapper discountQueryMapper;
	@Autowired
	private GoodsMapper goodsMapper;
	@Autowired
	private GoodsDetailMapper goodsDetailMapper;
	
	public List<Long> getGoodsDetailIds(DiscountQuery discountQuery) {
		return discountQueryMapper.getGoodsDetailIds(discountQuery);
	}

	public List<Map<String, Object>> goodsSum(List<Long> ids) {
		return discountQueryMapper.goodsSum(ids);
	}
	
	public void saveDiscount(String ids,double discount,Date starttime,Date endtime){
		List<Long> idlist=ids2Long(ids);
		for(Long id:idlist){
			Goods goods=new Goods();
			GoodsDetailExample goodsDetailExample=new GoodsDetailExample();
			goodsDetailExample.createCriteria().andGoodsidEqualTo(id);
			List<GoodsDetail> goodsDetails=goodsDetailMapper.selectByExample(goodsDetailExample);
			JSONObject priceJson=new JSONObject();
			JSONArray pricejsonArray=new JSONArray();
			double[] pricearray=new double[goodsDetails.size()];
			double[] vippricearray=new double[goodsDetails.size()];
			for(int i=0;i<goodsDetails.size();i++){
				GoodsDetail gd=goodsDetails.get(i);
				double newprice=NumberUtil.toFixed(NumberUtil.multiply(gd.getPrice(), discount/10), 2);
				gd.setVipprice(newprice);
				goodsDetailMapper.updateByPrimaryKeySelective(gd);
				
				//拼装价格json
				pricearray[i]=gd.getPrice();
				vippricearray[i]=newprice;
				JSONObject price=new JSONObject();
				price.put("id", gd.getId());
				price.put("price", gd.getPrice());
				pricejsonArray.add(price);
			}
			Arrays.sort(pricearray);
			Arrays.sort(vippricearray);
			priceJson.put("min", pricearray[0]);
			priceJson.put("max", pricearray[pricearray.length-1]);
			priceJson.put("vipmin", vippricearray[0]);
			priceJson.put("vipmax", vippricearray[vippricearray.length-1]);
			priceJson.put("prices", pricejsonArray);
			goods.setId(id);
			goods.setMinprice(vippricearray[0]<pricearray[0]?vippricearray[0]:pricearray[0]);
			goods.setStarttime(starttime);
			goods.setEndtime(endtime);
			goods.setDiscount(discount);
			goods.setPricejson(priceJson.toString());		//价格json
			goods.setIsdiscount(DateUtil.compareRange(starttime, endtime));
			goodsMapper.updateByPrimaryKeySelective(goods);
		}
	}
	
	public void calcelDiscount(String ids,String status){
		List<Long> idlist=ids2Long(ids);
		for(Long id:idlist){
			Goods goods=new Goods();
			GoodsDetailExample goodsDetailExample=new GoodsDetailExample();
			goodsDetailExample.createCriteria().andGoodsidEqualTo(id);
			List<GoodsDetail> goodsDetails=goodsDetailMapper.selectByExample(goodsDetailExample);
			JSONObject priceJson=new JSONObject();
			JSONArray pricejsonArray=new JSONArray();
			double[] pricearray=new double[goodsDetails.size()];
			for(int i=0;i<goodsDetails.size();i++){
				GoodsDetail gd=goodsDetails.get(i);
				gd.setVipprice(gd.getPrice());
				goodsDetailMapper.updateByPrimaryKeySelective(gd);
				
				//拼装价格json
				pricearray[i]=gd.getPrice();
				JSONObject price=new JSONObject();
				price.put("id", gd.getId());
				price.put("price", gd.getPrice());
				pricejsonArray.add(price);
			}
			Arrays.sort(pricearray);
			priceJson.put("min", pricearray[0]);
			priceJson.put("max", pricearray[pricearray.length-1]);
			priceJson.put("prices", pricejsonArray);
			goods.setId(id);
			goods.setMinprice(pricearray[0]);
			goods.setIsdiscount(status);
			goods.setDiscount(0.0);
			goods.setPricejson(priceJson.toString());		//价格json
			goodsMapper.updateByPrimaryKeySelective(goods);
		}
	}

	private List<Long> ids2Long(String ids){
		if(StringUtils.isEmpty(ids)){
			return null;
		}
		String[] idarray=ids.split(",");
		List<Long> idlist=new ArrayList<Long>();
		for(String id:idarray){
			idlist.add(Long.parseLong(id));
		}
		return idlist;
	}
}
