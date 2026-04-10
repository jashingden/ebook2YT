from PIL import Image
from dotenv import load_dotenv
import os

from paddleocr import PaddleOCR

ocr = PaddleOCR(
    use_doc_orientation_classify=False,
    use_doc_unwarping=False,
    use_textline_orientation=False)

load_dotenv()
ebook_dir = os.getenv("EBOOK_DIR")
ebook_txt = os.getenv("EBOOK_TXT")
ebook_cover = os.getenv("EBOOK_COVER")

def get_img_files():
    img_files = []
    for img_name in os.listdir(ebook_dir):
        if os.path.isfile(os.path.join(ebook_dir, img_name)):
            txt_name = os.path.splitext(img_name)[0] + '.txt'
            img_files.append((img_name, txt_name))
    return img_files

def crop_image(img_name, crop_area):
    input_path = ebook_dir + '/' + img_name
    output_path = ebook_dir + '/img/' + img_name
    with Image.open(input_path) as img:
        cropped_img = img.crop(crop_area)
        cropped_img.save(output_path)

def img2txt(img_name, txt_name):
    image_path = ebook_dir + '/img/' + img_name
    result = ocr.predict(input=image_path)
    ocrr = result[0]
    texts = ocrr.json['res']['rec_texts']
    polys = ocrr.json['res']['dt_polys']

    text_list = []
    for i in range(len(texts)-1, -1, -1):
        text_list.append( (polys[i][0][0], texts[i]))

    text_list.sort(reverse=True, key=lambda x: x[0])

    txt_path = ebook_dir + '/txt/' + txt_name
    with open(txt_path, 'w', encoding='utf-8') as f:
        for text in text_list:
            f.write(text[1] + '\n')


def merge_txt_files():
    txt_dir = ebook_dir + '/txt/'
    txt_files = [f for f in os.listdir(txt_dir) if f.endswith('.txt')]
    txt_files.sort()
    print(txt_dir + ' 找到 ' + str(len(txt_files)) + ' 個檔案')

    output_path = os.path.join(ebook_dir, ebook_txt)
    with open(output_path, 'w', encoding='utf-8') as out:
        for txt_file in txt_files:
            txt_path = os.path.join(txt_dir, txt_file)
            with open(txt_path, 'r', encoding='utf-8') as f:
                content = f.read() + '\n'
                out.write(content)
                print('合併文字完成 ' + txt_file)

    print(ebook_txt + '全部文字合併完成!')


def convert_img_to_txt():
    crop_area = (295, 25, 1630, 900)

    img_files = get_img_files()
    print(ebook_dir + ' 找到 ' + str(len(img_files)) + ' 個檔案')

    for img_name, txt_name in img_files:
        print('正在處理 ' + img_name)
        crop_image(img_name, crop_area)
        print('圖片裁切完成 ' + img_name)
        img2txt(img_name, txt_name)
        print('轉換文字完成 ' + txt_name)

    print('全部檔案處理完成!')

def crop_cover_img():
    # 240p (SD)：426x240
    crop_area = (650, 420, 1076, 660)
    crop_image(ebook_cover, crop_area)
    print('封面圖片裁切完成 ' + ebook_cover)


if __name__ == "__main__":
    #crop_cover_img()
    convert_img_to_txt()
    #merge_txt_files()

