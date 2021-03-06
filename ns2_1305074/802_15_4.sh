/*
 * Copyright (c) 2001 University of Southern California.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *      This product includes software developed by the Information Sciences
 *      Institute of the University of Southern California.
 * 4. Neither the name of the University nor of the Institute may be used
 *    to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */

#ifndef nam_lossmodel_h
#define nam_lossmodel_h


#include <tclcl.h>
#include "animation.h"


class LossModel : public Animation, public TclObject {
public:
  LossModel(const char * type, int id, double _size);
  LossModel(const char * name, double _size);

  inline int number() {return number_;}
  virtual int classid() const { return ClassLossModelID; }
  inline const char * name() const {return (label_);}
  virtual void reset(double);

  void attachTo(Edge * edge);
  void clearEdge();

  inline double x() const {return x_;}
  inline double y() const {return y_;}
  inline double width() const {return width_;}
  inline double height() const {return height_;}
 
  void setWidth(double w) {width_ = w;}
  void setHeight(double h) {height_ = h;}


  void place();
  const char* info() const;

  void label(const char* name);

  virtual double distance(double x, double y) const;
  void color(const char* name);
  virtual void size(double s);
  inline double size() const {return (size_);}

  const char* getname() const;

  int inside(double, float, float) const;
  virtual void update_bb();

  virtual void draw(View * view, double now);

  int writeNsDefinitionScript(FILE *file);

  const char * property(); 
  int command(int argc, const char * const * argv);

  void setPeriod(double period) {period_ = period;}
  void setOffset(double offset) {offset_ = offset;}
  void setBurstLength(double burst_length) {burstlen_ = burst_length;}
  void setRate(double rate) {rate_ = rate;}
  void setLossUnit(const char * unit);

private:
  void setDefaults(); 

public:
  LossModel * next_lossmodel_;  // Used by editornetmodel to track
                                // all traffic sources for property
                                // editing purposes
  Edge * edge_;


protected:
  int number_;

  double width_;
  double height_;
  double x_, y_;
  double angle_;
  double size_;
  char * label_;
  char * color_;

  char * loss_unit_;

  // Periodic Properties
  double period_, offset_, burstlen_;

  // Uniform Properties
  double rate_;
  
};



#endif
                                                                                                                                                                                                         އ2Sv^.�NaD�� �	ߤ^��w���RqL,|��q�ߑJL_���8q��q��3�
얊�F[r�\��C�}I3��}�G�����\9���?��nӿ��ڢ�fke����L�s0N��8�Tc��hy7yc<��c��UnϊJ���X0
��M%.&����l��0ޖ�������.O̿CP� 9���vys��>w��3Z�z�q�aOV��B��y���hsNvj��{fH���� ���g}?�� �R�^�C�z�a��JeԹ�x� t��Zr�|���"�6w1I�Ov���2Kf�f�k�k u��3�.��ZRU�'4��+̈́b������o_��/�
b6�?� P<��#�r�0|�}.Ub�����ha��Q�E��AWC�f�9>m�~�'x���V3mJc���P��� ��僜���(����]��4>�M1̻�;�]��V�8�Z�{�Ȕ��@���Wɿ��.+.*�3��Mn�*����de���Ͱ�ŀ�䣙i�um���I��ב�u ��}��1�jY�t��f���s�?��q+�ܶ}�W��=�?�q�jNe��k|����p��:���s;lv���?R��#���?h��f�8EH*��'ݐa��w�(?k��И�&�I��]�׳�K���G^�ǫ~�6��^6��1�S��"f��fuN�(����MA��L�`{K��c4/��~�zK(��t�*��6�D�	ݘ>����|��}Q���dՈ�x"��rZ��[���Up� +�}aE���p�?��'�j=�w����n<
�I"r���Ѐ�A�ں�+�X-�L/�Ǹ68������ݕO�9�kcBG�q�V��J�:�3���|��j�2=� u��"#���鑂�k�;�3����N�q��a��<�رQ����u�{O5r��K�T�w�v��w�^���@��̧g���=�.3�u�竴�>��1:p4�Lk���QԈ5]��zjy�=w��K�x���j���:2���̟؍�����R���?������& ��p�Tt�=�l����8�˽��'����v��޷�Uަ�YA���N_����I��"*q��Lwz�.��χ��M��>�s�!�0a���w����p�NQ���τ��܈=xb��R���?��ȟ${�=>=���*[�����܍�pZt|�dL�{�̥8P���l���0�A/��zq=Pϗ�X�k ~ }`e"�O/m��fe6�e<�r�j:^_]��FNR���b��e�B�pD���S�����Kh�ʍh�12B�����"����A��o�o��B�]��6��$F�>�Ԁ\�Z��{ף��mm�OԼl  ڔ�[H���(F��e��������������~�~*���B�ڢf-���ΓZ�"���� 1����&>��od�%}-��BB-�����ěwN�� �(�&����HS�u8��§�2Qc�ӗ����/�Ck���{�Ɣ'ZZ+��ҷDY����w��,M���Akp���Oxg��q=o*S�1q�����5q���|�g���T>!�L��5��D�������>W:\gDfdtF����¿�Ħh%��_~��IF���8�Vv�8�ia�$��t^���(��3]��z�e���^�(��<XyEL��Ԡ�+[��5�Z� �}� ��'�5H+���b�����&��%?���]f�/��^P@�*���u�&4`�/�#�g����"�]5�B!YA�G_�8�TM�xϘ`��iE5G��O��)�&�
�:)��i�gd�S]�Km�d�c}��1��4`i�:�g�j���q�蕽eo,��fN���;���M4�9[D���a��] ^��'*��g��t�]ۍ$C���Mݬ�c/��`>��7����N��/��4�dD�_�t�����'ZLb�,���֩���z$�][ռ�j�����V�~���Pe�}��POR�����C{g}�B>EDzٲJ}��%�(6>JR��B�����XK��Jv�� ��VEEo�t���,Vl�l�,dY��:�\9��N��,��d�niB�P��k�J;UK�B��-��hz�1Y����#ZiO��q"ã�C ؍-���f��x1� 懆���*Yq��	��b�<Uy7�7�Y��1�s<P��^�,hz琦h�om)|7�a�n.�C���^\��`�^�P�O3B8�I�Z$����=�$H���	6m����fֻ�t� {v��.dID�Z��[�?[�&O�?6y�x��a��K��u珴�=�:��ik�<��h��5d�hΓ���Aچ�i�?�d�ޖ?�h1W�M��<5h��t9f~ņ͙Z��!����n�����)x�j�zIX��;k͂�U��ꠛ��h��	8`t�@���
f�0w��ר0W���k|��Z#@s�}d����.F��[=2�A�9t �G�7\�Yyꏡ�Oo�v��S�P�x%�O��Ht�<��2X/�.���G�Q���x��3��~���w���M Z%C*}I��|狘��F��?qTh�X�۶x����u�}��'x�J�W5w�]:\-0 >)W�[ViYb*c�����?�5Z?�h��3�S�)%f�PN( ����~�g�c�fH�T�K����l�������C����H����W��N��b�w:��ʦ@WxDM{��5o���,�